class Skr.Screens.SalesOrder extends Skr.Screens.Base

    mixins:[
        Lanes.Screens.Mixins.Editing
    ]
    formBindings: true
    subviews:
        terms:
            component: 'SelectField'
            model: 'model'
            options: { association: 'terms'}
        customer:
            component: 'SelectField'
            model: 'model'
            options: { association: 'customer'}
        billaddr:
            component: 'Address'
            model: 'model.billing_address'
            options: { field_name: 'billing_address_id' }
        shipaddr:
            component: 'Address'
            model: 'model.shipping_address'
            options: ->{ copyFrom: this.billaddr, field_name: 'shipping_address_id' }

    finderOptions: ->
        modelClass: Skr.Models.SalesOrder
        title: 'Find Sales Order',
        invalid_chars: Skr.Models.Mixins.VisibleID.invalidChars
        withAssociations: []
        fields: ['visible_id', 'notes']
