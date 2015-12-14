Lanes::Screen.define_group 'accounting' do | group |
    group.title       = "Accounting"
    group.description = "Accounting functions"
    group.icon        = "line-chart"
end

Lanes::Screen.define_group 'maint' do | group |
    group.title       = "Maintenance"
    group.description = "Maintain records"
    group.icon        = "pencil-square"
end

Lanes::Screen.define_group 'customer' do | group |
    group.title       = "Customer"
    group.description = "Customer records"
    group.icon        = "heart"
end

Lanes::Screen.for_extension 'skr' do | screens |

    ## ACCOUNTING GROUP
    screens.define "time-invoicing" do | screen |
        screen.title       = "Time Invoicing"
        screen.description = ""
        screen.icon        = "hourglass"
        screen.group_id    = "accounting"
        screen.model_class = "Invoice"
        screen.view_class  = "TimeInvoicing"
    end
    screens.define "trial-balance" do | screen |
        screen.title       = "Trial Balance"
        screen.description = ""
        screen.icon        = "list-alt"
        screen.group_id    = "accounting"
        screen.model_class = "GlTransaction"
        screen.view_class  = "TrialBalance"
    end
    screens.define "gl-transactions" do | screen |
        screen.title       = "Gl Transactions"
        screen.description = ""
        screen.icon        = "balance-scale"
        screen.group_id    = "accounting"
        screen.model_class = "GlTransaction"
        screen.view_class  = "GlTransactions"
    end
    screens.define "customer-projects" do | screen |
        screen.title       = "Customer Projects"
        screen.description = ""
        screen.icon        = "briefcase"
        screen.group_id    = "accounting"
        screen.model_class = "Invoice"
        screen.view_class  = "CustomerProjects"
    end
    screens.define "invoice" do | screen |
        screen.title       = "Invoice"
        screen.description = "Invoices"
        screen.icon        = "money"
        screen.group_id    = "accounting"
        screen.model_class = "Invoice"
        screen.view_class  = "Invoice"
    end
    screens.define "customer-maint" do | screen |
        screen.title       = "Customer Maintenance"
        screen.icon        = "heartbeat"
        screen.group_id    = "maint"
        screen.model_class = "Customer"
        screen.view_class  = "CustomerMaint"
    end

    # MAINT GROUP
    screens.define "sku-maint" do | screen |
        screen.title       = "SKU Maintenance"
        screen.icon        = "archive"
        screen.group_id    = "maint"
        screen.model_class = "Sku"
        screen.view_class  = "SkuMaint"
    end
    screens.define "vendor-maint" do | screen |
        screen.title       = "Vendor Maintenance"
        screen.icon        = "truck"
        screen.group_id    = "maint"
        screen.model_class = "Vendor"
        screen.view_class  = "VendorMaint"
    end

    # CUSTOMER
    screens.define "sales-order" do | screen |
        screen.title       = "Sales Order"
        screen.description = ""
        screen.icon        = "shopping-cart"
        screen.group_id    = "customer"
        screen.model_class = "SalesOrder"
        screen.view_class  = "SalesOrder"
    end
    screens.define "time-tracking" do | screen |
        screen.title       = "Time Tracking"
        screen.description = ""
        screen.icon        = "hourglass-start"
        screen.group_id    = "customer"
        screen.model_class = "TimeEntry"
        screen.view_class  = "TimeTracking"
    end
end
