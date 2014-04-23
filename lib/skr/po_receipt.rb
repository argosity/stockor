module Skr

    # Is a record of an inventory receipt
    # A {PurchaseOrder} can have one or more of them

    class PoReceipt < Skr::Model

        has_visible_id
        has_sku_loc_lines
        has_gl_transaction

        belongs_to :purchase_order, export: true
        belongs_to :vendor,   export: true
        belongs_to :location, export: true

        has_one :gl_transaction, :as=>:source

        has_many :lines, :class_name=>'PorLine', export: { writable: true },
                 inverse_of: :po_receipt, autosave: true, validate: true

        validates :freight,        numericality: true
        validates :purchase_order, :location, presence: true

        before_create  :record_freight, if: ->{ freight.nonzero? }
        after_create   :logit

        def purchase_order=(po)
            super
            self.location   ||= purchase_order.location
            self.vendor     = purchase_order.vendor
        end

        private

        def attributes_for_gl_transaction
            {   location: location, source: self,
                description: "PO RECPT #{self.visible_id}" }
        end

        def logit
        end

        def record_freight
            GlTransaction.current.add_posting( amount: self.freight,
              debit: GlAccount.default_for( :inventory_receipts_clearing ),
              credit: vendor.gl_freight_account
            )
        end

    end

end
