class Skr.Data.Vendor extends Skr.Data.Model
    name: 'Vendor'
    associations:[
        {
            name : 'billing_address'
            model: 'Address'

        },{
            name  : 'shipping_address'
            model : 'Address'
        }
    ]

    @include Skr.Data.mixins.HasCodeField

class Skr.Data.Vendors extends Skr.Data.Collection
    model: Skr.Data.Vendor
