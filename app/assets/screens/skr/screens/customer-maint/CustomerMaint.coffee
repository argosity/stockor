class Skr.View.Screens.CustomerMaint extends Skr.View.Screen

    template: 'skr/screens/customer-maint/template'
    subViews:
        finder:
            selector: '.finder'
            component: 'RecordFinder'
            options: 'finderOptions'
        select:
            selector: '.selector'
            component: 'SelectField'
            options: 'selectOptions'
        billaddr:
            selector: '.addresses .bill'
            component: 'Address'
            model: 'model.billing_address'
        shipaddr:
            selector: '.addresses .ship'
            component: 'Address'
            model: 'model.shipping_address'
            arguments: -> { copyFrom: this.subViewInstances['.addresses .bill'] }

    selectOptions: ->
        collection: Skr.Data.GlAccounts

    finderOptions:
        collection: Skr.Data.Customers
        arguments:
            title: 'Customer Maint'
            columns: [
                {field:'code',type:'s'}
                {field:'name',type:'s'}
                {field:'notes',type:'s'}
                {field:'credit_limit',type:'n'}
            ]

    bindings:
        model:
            default: true, el: '.header'

    events:
        'click .btn.save':  'save'
        'click .btn.reset': 'reset'
        'display-record':   'load'

    reset: ->
        this.setData( model: new Skr.Data.Customer )

    save: ->
        Skr.View.SaveNotify(this, callback: (success,resp)->
        )

    initialize: ->
        @model=new Skr.Data.Customer
        super

    load: (ev,customer)->
        customer.ensureAssociations( 'billing_address', 'shipping_address', (model)->
            this.setData(model:model)
        ,this)
