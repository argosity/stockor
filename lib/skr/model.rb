module Skr

    class Model < Lanes::Model
        self.abstract_class = true

        include Concerns::ActsAsUOM
        include Concerns::StateMachine
        include Concerns::HasSkuLocLines
        include Concerns::HasGlTransaction
        include Concerns::IsOrderLike
        include Concerns::IsSkuLocLine
        include Concerns::ImmutableModel
        include Concerns::VisibleIdIdentifier
        include Concerns::LockedFields
        include Concerns::RandomHashCode
    end

    autoload :Address,              "skr/models/address"
    autoload :BusinessEntity,       "skr/models/business_entity"
    autoload :Customer,             "skr/models/customer"
    autoload :GlAccount,            "skr/models/gl_account"
    autoload :GlManualEntry,        "skr/models/gl_manual_entry"
    autoload :GlPeriod,             "skr/models/gl_period"
    autoload :GlPosting,            "skr/models/gl_posting"
    autoload :GlTransaction,        "skr/models/gl_transaction"
    autoload :IaLine,               "skr/models/ia_line"
    autoload :IaReason,             "skr/models/ia_reason"
    autoload :InvLine,              "skr/models/inv_line"
    autoload :InventoryAdjustment,  "skr/models/inventory_adjustment"
    autoload :Invoice,              "skr/models/invoice"
    autoload :Location,             "skr/models/location"
    autoload :PaymentTerm,          "skr/models/payment_term"
    autoload :PickTicket,           "skr/models/pick_ticket"
    autoload :PoLine,               "skr/models/po_line"
    autoload :PoReceipt,            "skr/models/po_receipt"
    autoload :PorLine,              "skr/models/por_line"
    autoload :PtLine,               "skr/models/pt_line"
    autoload :PurchaseOrder,        "skr/models/purchase_order"
    autoload :SalesOrder,           "skr/models/sales_order"
    autoload :SequentialId,         "skr/models/sequential_id"
    autoload :Sku,                  "skr/models/sku"
    autoload :SkuLoc,               "skr/models/sku_loc"
    autoload :SkuTran,              "skr/models/sku_tran"
    autoload :SkuVendor,            "skr/models/sku_vendor"
    autoload :SoLine,               "skr/models/so_line"
    autoload :Uom,                  "skr/models/uom"
    autoload :UserProxy,            "skr/models/user_proxy"
    autoload :DocumentsController,  "skr/models/user_proxy"
    autoload :Vendor,               "skr/models/vendor"
    autoload :VoLine,               "skr/models/vo_line"
    autoload :Voucher,              "skr/models/voucher"
    autoload :TimeEntry,            "skr/models/time_entry"
    autoload :CustomerProject,      "skr/models/customer_project"
    autoload :BankAccount,          "skr/models/bank_account"
    autoload :PaymentCategory,      "skr/models/payment_category"
    autoload :Payment,              "skr/models/payment"
    autoload :ExpenseCategory,      "skr/models/expense_category"
    autoload :ExpenseEntry,         "skr/models/expense_entry"
    autoload :ExpenseEntryCategory, "skr/models/expense_entry_category"
    autoload :Event,                "skr/models/event"
    autoload :EventInvoiceXref,     "skr/models/event_invoice_xref"
end
