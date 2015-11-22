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
Lanes::Screen.for_extension 'Skr' do | screens |

    ## ACCOUNTING GROUP
    screens.define "time-invoicing" do | screen |
        screen.title       = "Time Invoicing"
        screen.description = ""
        screen.icon        = "hourglass"
        screen.group_id    = "accounting"
        screen.model_class = "Invoice"
        screen.view_class  = "TimeInvoicing"
        screen.js          = "time-invoicing.js"
        screen.css         = "time-invoicing.css"
    end
    screens.define "customer-projects" do | screen |
        screen.title       = "Customer Projects"
        screen.description = ""
        screen.icon        = "briefcase"
        screen.group_id    = "accounting"
        screen.model_class = "Invoice"
        screen.view_class  = "CustomerProjects"
        screen.js          = "customer-projects.js"
        screen.css         = "customer-projects.css"
    end
    screens.define "invoice" do | screen |
        screen.title       = "Invoice"
        screen.description = "Invoices"
        screen.icon        = "money"
        screen.group_id    = "accounting"
        screen.model_class = "Invoice"
        screen.view_class  = "Invoice"
        screen.js          = "invoice.js"
        screen.css         = "invoice.css"
    end
    screens.define "customer-maint" do | screen |
        screen.title       = "Customer Maintenance"
        screen.icon        = "heartbeat"
        screen.group_id    = "maint"
        screen.model_class = "Customer"
        screen.view_class  = "CustomerMaint"
        screen.js          = 'customer-maint.js'
        screen.css         = 'customer-maint.css'
    end

    # MAINT GROUP
    screens.define "sku-maint" do | screen |
        screen.title       = "SKU Maintenance"
        screen.icon        = "archive"
        screen.group_id    = "maint"
        screen.model_class = "Sku"
        screen.view_class  = "SkuMaint"
        screen.js          = "sku-maint.js"
        screen.css         = "sku-maint.css"
    end
    screens.define "vendor-maint" do | screen |
        screen.title       = "Vendor Maintenance"
        screen.icon        = "truck"
        screen.group_id    = "maint"
        screen.model_class = "Vendor"
        screen.view_class  = "VendorMaint"
        screen.js          = "vendor-maint.js"
        screen.css         = "vendor-maint.css"
    end

    # CUSTOMER
    screens.define "sales-order" do | screen |
        screen.title       = "Sales Order"
        screen.description = ""
        screen.icon        = "shopping-cart"
        screen.group_id    = "customer"
        screen.model_class = "SalesOrder"
        screen.view_class  = "SalesOrder"
        screen.js          = "sales-order.js"
        screen.css         = "sales-order.css"
    end
    screens.define "time-tracking" do | screen |
        screen.title       = "Time Tracking"
        screen.description = ""
        screen.icon        = "hourglass-start"
        screen.group_id    = "customer"
        screen.model_class = "TimeEntry"
        screen.view_class  = "TimeTracking"
        screen.js          = "time-tracking.js"
        screen.css         = "time-tracking.css"
    end
end
