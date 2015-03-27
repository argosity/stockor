class Skr.Screens.VendorMaint extends Skr.Screens.Base

    mixins:[
        Skr.Screens.Mixins.Editing
    ]

    useFormBindings: true

    subviews:
        terms:
            component: 'SelectField'
            model: 'model'
            options: { association: 'terms', mappings: { title: 'code' } }
        billaddr:
            component: 'Address'
            model: 'model.billing_address'
            options: { field_name: 'billing_address_id' }
        shipaddr:
            component: 'Address'
            model: 'model.shipping_address'
            options: ->{ copyFrom: this.billaddr, field_name: 'shipping_address_id' }

    finderOptions: ->
        modelClass: Skr.Models.Vendor
        title: 'Find Vendor',
        invalid_chars: Skr.Models.Mixins.CodeField.invalidChars
        withAssociations: ['billing_address', 'shipping_address', 'terms']
        fields: [ 'code', 'name', 'notes' ]
