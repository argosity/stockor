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
    screens.define "customer-maint" do | screen |
        screen.title       = "Customer Maintenance"
        screen.icon        = "heartbeat"
        screen.group_id    = "maint"
        screen.model_class = "Customer"
        screen.view_class  = "CustomerMaint"
        screen.js          = 'customer-maint.js'
        screen.css         = 'customer-maint.css'
    end
    # screens.define "sku-maint" do | screen |
    #     screen.title       = "SKU Maintenance"
    #     screen.icon        = "archive"
    #     screen.group_id    = "maint"
    #     screen.model_class = "Sku"
    #     screen.view_class  = "SkuMaint"
    #     screen.js          = "sku-maint.js"
    #     screen.css         = "sku-maint.css"
    # end
    screens.define "vendor-maint" do | screen |
        screen.title       = "Vendor Maintenance"
        screen.icon        = "truck"
        screen.group_id    = "maint"
        screen.model_class = "Vendor"
        screen.view_class  = "VendorMaint"
        screen.js          = "vendor-maint.js"
        screen.css         = "vendor-maint.css"
    end
    # screens.define "sales-order" do | screen |
    #     screen.title       = "Sales Order"
    #     screen.description = ""
    #     screen.icon        = "shopping-cart"
    #     screen.group_id    = "customer"
    #     screen.model_class = "SalesOrder"
    #     screen.view_class  = "Skr.Screens.SalesOrder"
    #     screen.js          = "sales-order.js"
    #     screen.css         = "sales-order.css"
    # end
end
