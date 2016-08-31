module Skr

    class InvLine < Skr::Model

        acts_as_uom

        is_sku_loc_line parent: "invoice"

        locked_fields :qty, :sku_loc_id, :so_line
        belongs_to :invoice

        belongs_to :so_line, export: true
        belongs_to :time_entry, export: true
        belongs_to :pt_line, :inverse_of=>:inv_line, export: true
        belongs_to :sku_loc, export: true

        has_one :sku, :through => :sku_loc, export: true
        has_one :location, :through => :sku_loc

        has_many :sku_trans, :as=>:origin, autosave: true
        has_many :uom_choices, :through => :sku, :source => :uoms, export: true

        validates :sku_loc,  set: true
        validates :price, :qty, :numericality=>true
        validates :uom_code, :sku_code, :description, :uom_size, :presence=>true
        validate  :ensure_unlocked

        before_validation :set_defaults
        before_save :perform_adjustments
        before_destroy :prevent_destroy

        scope :with_details, lambda { |should_use=true |
            compose_query_using_detail_view( view: 'inv_details', join_to: 'inv_line_id' ) if should_use
        }, export: true

        scope :summarize_by, lambda { | values |
            select( "sum(inv_lines.qty) as qty, count(*) as num_sales, sum(inv_lines.price) as price, " \
                    "avg(inv_lines.price) as avg_price, s.code as sku_code, s.description, " \
                    "s.id as sku_id, 1 as uom_size, 'EA' as uom_code")
            .joins("join sku_locs sl on sl.id = inv_lines.sku_loc_id join skus s on s.id = sl.sku_id")
            .where(["inv_lines.created_at between ? and ?",values['from'], values['to'] ])
            .group('s.code,s.description, s.id')
        }, export: true

        def total
            (qty||0) * (price||0)
        end

        def ensure_unlocked
            if invoice.is_locked?
                self.errors.add(:invoice_date, "invoice date falls on a locked GL Period")
            end
        end

      private

        def set_defaults
#           puts "set_defaults #{self}"
            line = [ self.pt_line, self.so_line ].detect{ |l| ! l.blank? }
            if line
                self.uom         = line.uom if self.uom.blank?
                self.sku_code    = line.sku_code
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
            if !price && invoice && invoice.customer && sku_loc && uom.present?
                self.price = Skr.config.pricing_provider.price(
                  sku_loc:sku_loc,  customer:invoice.customer,
                  uom:uom, qty: qty )
            end
            true
        end

        def perform_adjustments
            debit  = self.sku.gl_asset_account
            credit = self.invoice.customer.gl_receivables_account
            old_extended_price = self.price_was && self.qty_was ?
                                     self.price_was * self.qty_was : BigDecimal.new(0)
            price_change = self.extended_price - old_extended_price

            if self.sku.does_track_inventory?
                changed_qty = self.qty - (qty_was || 0)
                self.sku_trans.build(
                    origin: self, qty: changed_qty * -1, sku_loc: self.sku_loc, uom: self.uom,
                    mac: 0, cost: price_change,
                    origin_description: gl_origin_description,
                    debit_gl_account:  debit, credit_gl_account: credit
                )
            else
                GlTransaction.push_or_save(
                  owner: self, amount: price_change,
                  debit: debit, credit: credit,
                  options: {description: gl_origin_description}
                )
            end
            true
        end

        def gl_origin_description
            "INV #{self.invoice.visible_id}:#{self.sku.code}"
        end

        def prevent_destroy
            errors.add(:base, "Can not destroy #{self.class.model_name}, only create/modify is allowed" )
        end
    end

end # Skr module
