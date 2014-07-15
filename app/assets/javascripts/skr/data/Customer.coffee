
class Customer
    constructor: -> super

    mixins: [
        Skr.Data.mixins.HasCodeField
    ]

    title: 'Customers'

    props_schema:
        string: ['code','name','notes','website']
        number: ['billing_address_id','shipping_address_id','terms_id','gl_receivables_account_id']
        object: ['options']

    associations:
            billing_address_id: 'Skr.Data.Address'
            shipping_address_id: 'Skr.Data.Address'

Skr.Data.Customer = Skr.Data.Model.extend(Customer)
