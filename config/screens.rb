Lanes::Screen.define_group 'customer' do | group |
    group.title       = "Customers"
    group.description = "Maintain records related to Customers"
    group.icon        = "icon-users"
end


Lanes::Screen.define "customer-maint" do | screen |
    screen.title       = "Customer Maintenance"
    screen.icon        = "icon-wrench2"
    screen.group_id    = "customer"
    screen.model_class = "Customer"
    screen.view_class  = "Skr.Screens.CustomerMaint"
    screen.js          = 'skr/screens/customer-maint.js'
    screen.css         = 'skr/screens/customer-maint.css'
end

