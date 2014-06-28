class Skr.View.Screens.VendorMaint extends Skr.View.Screen

    template: 'skr/screens/vendor-maint/template'
    subViews:
        finder:
            selector: '.finder'
            component: 'RecordFinder'
            options: 'finderOptions'
        billaddr:
            selector: '.addresses .bill'
            component: 'Address'
            model: 'model.billing_address'
        shipaddr:
            selector: '.addresses .ship'
            component: 'Address'
            model: 'model.shipping_address'
            arguments: -> { copyFrom: this.subViewInstances['.addresses .bill'] }

    finderOptions:
        collection: Skr.Data.Vendors
        arguments:
            title: 'Vendor Maint'
            columns: [
                {field:'code',type:'s'}
                {field:'name',type:'s'}
                {field:'notes',type:'s'}

            ]

    bindings:
        model:
            default: true, el: '.header'

    events:
        'click .btn.save':  'save'
        'click .btn.reset': 'reset'
        'display-record':   'load'

    reset: ->
        this.setData( model: new Skr.Data.Vendor )

    save: ->
        Skr.View.SaveNotify(this, callback: (success,resp)->
        )

    initialize: ->
        @model=new Skr.Data.Vendor
        super

    load: (ev,vendor)->
        vendor.ensureAssociations( 'billing_address', 'shipping_address', (model)->
            this.setData(model:model)
        ,this)
