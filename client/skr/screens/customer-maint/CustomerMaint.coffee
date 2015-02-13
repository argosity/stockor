class Skr.Screens.CustomerMaint extends Skr.Screens.Base

    FILE: FILE

    constructor: ->
        super
        this.reset()

    useFormBindings: true

    domEvents:
        'click .btn.save':  'save'
        'click .btn.reset': 'reset'
        'display-record':   'onRecordTrigger'

    subviews:
        finder:
            component: 'RecordFinder'
            options: 'finderOptions'
            model: 'model'
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
        modelClass: Skr.Models.Customer
        title: 'Find Customer',
        invalid_chars: Skr.Models.Mixins.CodeField.invalidChars
        withAssociations: ['billing_address', 'shipping_address', 'terms']
        fields: [ 'code', 'name', 'notes', 'credit_limit' ]

    reset: ->
        this.model = new Skr.Models.Customer

    save: ->
        Lanes.Views.SaveNotify(this, include:['billing_address','shipping_address','terms'])

    onRecordTrigger: (ev, model)->
        this.model = model
        window.c = model
