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
    # System Settings
    screens.define "locations" do | screen |
        screen.title       = "Locations"
        screen.description = ""
        screen.icon        = "globe"
        screen.group_id    = "system-settings"
        screen.model_class = "Location"
        screen.view_class  = "Locations"
    end
    screens.define "fresh-books-import" do | screen |
        screen.title       = "Fresh Books Import"
        screen.description = ""
        screen.icon        = "cloud-download"
        screen.group_id    = "system-settings"
        screen.model_class = "Invoice"
        screen.view_class  = "FreshBooksImport"
    end

    ## ACCOUNTING GROUP
    screens.define "time-invoicing" do | screen |
        screen.title       = "Time Invoicing"
        screen.description = ""
        screen.icon        = "hourglass"
        screen.group_id    = "accounting"
        screen.model_class = "Invoice"
        screen.model_access = "write"
        screen.view_class  = "TimeInvoicing"
    end
    screens.define "payments" do | screen |
        screen.title       = "Payments"
        screen.description = ""
        screen.icon        = "file-text-o"
        screen.group_id    = "accounting"
        screen.model_class = "Payment"
        screen.view_class  = "Payments"
    end
    screens.define "bank-maint" do | screen |
        screen.title       = "Bank Maint"
        screen.description = ""
        screen.icon        = "bank"
        screen.group_id    = "accounting"
        screen.model_class = "BankAccount"
        screen.view_class  = "BankMaint"
    end
    screens.define "payment-terms" do | screen |
        screen.title       = "Payment Terms"
        screen.description = ""
        screen.icon        = "money"
        screen.group_id    = "accounting"
        screen.model_access = "write"
        screen.model_class = "PaymentTerm"
        screen.view_class  = "PaymentTerms"
    end
    screens.define "payment-category" do | screen |
        screen.title       = "Payment Categories"
        screen.description = ""
        screen.icon        = "object-group"
        screen.group_id    = "accounting"
        screen.model_class = "PaymentCategory"
        screen.view_class  = "PaymentCategory"
    end
    screens.define "chart-of-accounts" do | screen |
        screen.title       = "Chart Of Accounts"
        screen.description = ""
        screen.icon        = "list-alt"
        screen.group_id    = "accounting"
        screen.model_class = "GlTransaction"
        screen.view_class  = "ChartOfAccounts"
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
        screen.model_access = "write"
        screen.model_class = "Invoice"
        screen.view_class  = "CustomerProjects"
    end

    # MAINT GROUP
    screens.define "sku-maint" do | screen |
        screen.title       = "SKU Maintenance"
        screen.icon        = "archive"
        screen.group_id    = "maint"
        screen.model_class = "Sku"
        screen.view_class  = "SkuMaint"
    end
    screens.define "customer-maint" do | screen |
        screen.title       = "Customer Maintenance"
        screen.icon        = "heartbeat"
        screen.group_id    = "maint"
        screen.model_class = "Customer"
        screen.view_class  = "CustomerMaint"
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
    screens.define "invoice" do | screen |
        screen.title       = "Invoice"
        screen.description = "Invoices"
        screen.icon        = "money"
        screen.group_id    = "customer"
        screen.model_class = "Invoice"
        screen.view_class  = "Invoice"
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
