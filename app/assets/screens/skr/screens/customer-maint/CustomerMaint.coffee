class Skr.View.Screens.CustomerMaint extends Skr.View.Screen

    template: 'customer-maint'
    subViews:
        '.finder':
            component: 'RecordFinder'
            options: 'finderOptions'
        '.addresses .bill':
            component: 'Address'
            model: 'model.billing_address'
        '.addresses .ship':
            component: 'Address'
            model: 'model.shipping_address'


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
            console.log model.attributes
            window.c=model
            this.setData(model:model)
        ,this)



    render: ->
        super
        # Skr.u.delay( =>
        #     Skr.View.SaveNotify(this, callback: (success,resp,model)->
        #         console.log("Save: #{success}")
        #     )
        # ,500)
        this
