module Skr

    # Is a record of an inventory receipt
    # A {PurchaseOrder} can have one or more of them

    class PoReceipt < Skr::Model

        has_visible_id

        has_sku_loc_lines

        belongs_to :purchase_order, export: true
        belongs_to :vendor,   export: true
        belongs_to :location, export: true

        has_one :gl_transaction, :as=>:source

        has_many :lines, :class_name=>'PorLine', export: { writable: true },
                 inverse_of: :po_receipt, autosave: true, validate: true

        validates :freight,        numericality: true

        before_validation :set_defaults, :on=>:create

        around_create  :create_gl_transaction

        def purchase_order=(po)
            super
            self.location   ||= purchase_order.location
            self.vendor     = purchase_order.vendor
        end
        private


        def set_defaults
            true
        end

        def create_gl_transaction
            options = { source: self, location: location,
                description: "PO #{self.purchase_order.visible_id}, RECPT #{self.visible_id}" }
            GlTransaction.record( options ) do | tran |
                if self.freight.nonzero?
                    tran.add_posting( amount: self.freight,
                      debit: GlAccount.default_for( :inventory_receipts_clearing ),
                      credit: vendor.gl_freight_account
                    )

                end
                yield
            end
        end
    end
end
