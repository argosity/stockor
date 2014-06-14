class Skr.Data.Customer extends Skr.Data.Model
    name: 'Customer'
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

class Skr.Data.Customers extends Skr.Data.Collection
    model: Skr.Data.Customer
