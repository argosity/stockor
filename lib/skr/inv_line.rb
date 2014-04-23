module Skr

    class InvLine < Skr::Model

        acts_as_uom
        is_immutable
        is_sku_loc_line parent: "invoice"

        locked_fields :qty, :sku_loc_id, :so_line
        belongs_to :invoice

        belongs_to :so_line, export: true
        belongs_to :pt_line, :inverse_of=>:inv_line, export: true
        belongs_to :sku_loc, export: true

        has_one :sku, :through => :sku_loc, export: true
        has_one :location, :through => :sku_loc
        has_one :sku_tran, :as=>:origin

        validates :sku_loc,  set: true

        validates :price, :qty, :numericality=>true
        validates :uom_code, :sku_code, :description, :uom_size, :presence=>true

        before_validation :set_defaults
        before_save :adjust_inventory

        scope :with_details, lambda { |should_use=true |
            compose_query_using_detail_view( view: 'inv_details', join_to: 'inv_line_id' ) if should_use
        }, export: true

        scope :summarize_by, lambda { | values |
            select( "sum(inv_lines.qty) as qty, count(*) as num_sales, sum(inv_lines.price) as price, avg(inv_lines.price) as avg_price, s.code as sku_code, s.description, s.id as sku_id, 1 as uom_size, 'EA' as uom_code")
            .joins("join sku_locs sl on sl.id = inv_lines.sku_loc_id join skus s on s.id = sl.sku_id")
            .where(["inv_lines.created_at between ? and ?",values['from'], values['to'] ])
            .group('s.code,s.description, s.id')
        }, export: true


        private

        def set_defaults
#           puts "set_defaults #{self}"
            line = [ self.pt_line, self.so_line ].detect{ |l| ! l.blank? }
            if line
                self.uom         = line.uom if self.uom.blank?
                self.sku_code    ||= line.sku_code
                self.description ||= line.description
                self.sku_loc     ||= line.sku_loc
                self.qty         ||= line.qty
                self.so_line     ||= line.so_line
            elsif sku
                self.uom           = sku.uoms.default if self.uom_code.blank?
                self.sku_code    ||= sku.code
                self.description ||= sku.description
                self.sku_loc_id  ||= sku.sku_locs.for_location( self.invoice.location ).id if self.invoice && self.invoice.location
            end
            if self.invoice && self.invoice.customer && sku_loc && self.uom.present?
                self.price       ||= sku_loc.price_for( self.invoice.customer, self.uom )
            end
            true
        end

        def adjust_inventory
            debit  = self.sku.gl_asset_account
            credit = self.invoice.customer.gl_receivables_account
            if self.sku.does_track_inventory?
                self.build_sku_tran({
                    origin: self, qty: self.qty*-1, sku_loc: self.sku_loc, uom: self.uom,
                    mac: 0, cost: self.extended_price,
                    origin_description: "INV #{self.invoice.visible_id}:#{self.sku.code}",
                    debit_gl_account:  debit, credit_gl_account: credit
                })
            else
                GlTransaction.push_or_save(
                  owner: self, amount: self.total,
                  debit: debit, credit: credit
                )
            end
            true
        end



    end


end # Skr module
