Lanes::Screen.define_group 'maint' do | group |
    group.title       = "Maintenance"
    group.description = "Maintain records"
    group.icon        = "icon-wrench"
end


Lanes::Screen.define "customer-maint" do | screen |
    screen.title       = "Customer Maintenance"
    screen.icon        = "icon-users"
    screen.group_id    = "maint"
    screen.model_class = "Customer"
    screen.view_class  = "Skr.Screens.CustomerMaint"
    screen.js          = 'skr/screens/customer-maint.js'
    screen.css         = 'skr/screens/customer-maint.css'
end

Lanes::Screen.define "sku-maint" do | screen |
    screen.title       = "SKU Maintenance"
    screen.icon        = "icon-gift"
    screen.group_id    = "maint"
    screen.model_class = "Sku"
    screen.view_class  = "Skr.Screens.SkuMaint"
    screen.js          = "skr/screens/sku-maint.js"
    screen.css         = "skr/screens/sku-maint.css"
end

Lanes::Screen.define "vendor-maint" do | screen |
    screen.title       = "Vendor Maintenance"
    screen.icon        = "icon-truck"
    screen.group_id    = "maint"
    screen.model_class = "Vendor"
    screen.view_class  = "Skr.Screens.VendorMaint"
    screen.js          = "skr/screens/vendor-maint.js"
    screen.css         = "skr/screens/vendor-maint.css"
end
