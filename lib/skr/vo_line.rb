module Skr

    class VoLine < Skr::Model

        acts_as_uom
        is_immutable  except: 'price'
        is_order_line parent: 'voucher'

        belongs_to :voucher
        belongs_to :sku_loc,    export: true
        belongs_to :po_line,    export: true
        belongs_to :sku_vendor, export: true

        has_one :sku, :through => :sku_loc, export: true

        has_many :sku_trans, :as=>:origin

        attr_accessor :auto_allocate
        whitelist_json_attributes :auto_allocate

        validates :sku_loc, :sku_vendor, :po_line, :voucher, :set=>true
        validates :sku_code, :description, :sku_code, :presence => true
        validate  :ensure_qty_is_less_than_unreceived
        validate :qty, numericality: { gt: 0 }

        after_create  :record_in_gl
        after_update  :adjust_gl

        def po_line=(pol)
            super
            %w{ sku_code part_code description uom_code uom_size }.each do | attr |
                self[ attr ] = po_line[ attr ]
            end
            self.sku_loc    = pol.sku_loc
            self.sku_vendor = pol.sku_vendor
            self.uom   = pol.uom
            self.price = pol.price
            self.qty   = pol.qty_unreceived
        end

        def location
            if self.po_line.nil?
                Tenant.default_location
            else
                po_line.location
            end
        end

        private

        def adjust_gl
            diff = price - price_was
            return if diff.zero?

            tran = self.sku_trans.build({ :origin=>self, :qty => 0, :sku_loc=>po_line.sku_loc,
                :credit_gl_account => self.sku.gl_asset_account,
                :uom_size=>self.uom_size, :uom_code=>self.uom_code })

            tran.cost = diff * qty

            tran.debit_gl_account = if voucher.confirmed?
                                        voucher.vendor.gl_payables_account
                                    else # otherwise it's in the clearing account
                                        GlAccount.default_for( :inventory_receipts_clearing )
                                    end
            tran.save!

        end

        def record_in_gl
            Core.logger.debug( "Receiving #{self.ea_qty} into stock" )

            self.sku_trans.create!({
                origin: self, qty: self.qty,
                sku_loc: po_line.sku_loc,
                origin_description: "PO #{self.po_line.purchase_order.visible_id}",
                cost: self.total,  uom: self.uom,
                credit_gl_account: self.sku.gl_asset_account,
                debit_gl_account:  GlAccount.default_for( :inventory_receipts_clearing )
            })

            if self.auto_allocate
                tran.sku_loc.allocate_available_qty!
            end
            true
        end

        def ensure_qty_is_less_than_unreceived
            if qty_changed? && po_line && qty > po_line.qty_unreceived
                errors.add(:qty,"#{qty} must be less than unreceived qty of #{po_line.qty_unreceived}")
            end
        end

    end


end # Skr module
