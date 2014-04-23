module Skr

    class PorLine < Skr::Model

        acts_as_uom
        is_sku_loc_line parent: 'po_receipt'

        belongs_to :po_receipt
        belongs_to :sku_loc,    export: true
        belongs_to :po_line,    export: true
        belongs_to :sku_vendor, export: true

        has_one :sku, :through => :sku_loc, export: true

        has_many :sku_trans, :as=>:origin, validate: true

        before_create  :adjust_inventory
        # after_update  :adjust_gl
        validates :qty, numericality: { greater_than: 0 }

        json_attr_accessor :auto_allocate

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

        private

        def adjust_inventory
            Core.logger.debug( "Receiving #{self.ea_qty} into stock" )
            tran = self.sku_trans.build({
                origin: self, qty: self.qty,
                sku_loc: po_line.sku_loc,
                origin_description: "PO #{self.po_line.purchase_order.visible_id}",
                cost: self.extended_price,  uom: self.uom,
                credit_gl_account: self.sku.gl_asset_account,
                debit_gl_account:  GlAccount.default_for( :inventory_receipts_clearing )
            })
            if self.auto_allocate
                tran.allocate_after_save = true
            end
            true
        end

        def ensure_qty_is_less_than_unreceived
            if qty_changed? && po_line && qty > po_line.qty_unreceived
                errors.add(:qty,"#{qty} must be less than unreceived qty of #{po_line.qty_unreceived}")
            end
        end

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


    end
end
