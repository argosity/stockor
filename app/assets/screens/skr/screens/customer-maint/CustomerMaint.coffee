class CustomerMaint

    constructor: -> super

    templateName: 'skr/screens/customer-maint/template'

    subviews:
        finder:
            role: 'finder'
            component: 'RecordFinder'
            options: 'finderOptions'
            waitForm: 'model'
        billaddr:
            role: 'bill-addr'
            component: 'Address'
            waitFor: 'model.billing_address'
        shipaddr:
            role: 'ship-addr'
            component: 'Address'
            waitFor: 'model.shipping_address'

    initialize: ->
        @model=new Skr.Data.Customer
        # @defer( ->
        #     this.$('.record-finder-query').click()
        # , delay: 1 )

    formBindings:
        'model': '.header'

    selectOptions: ->
        collection: Skr.Data.GlAccounts

    finderOptions: ->
        query_using: Skr.Data.Customer.Collection
        title: 'Customer Maint'
        columns: [
            {field:'code',type:'s'}
            {field:'name',type:'s'}
            {field:'notes',type:'s'}
            {field:'credit_limit',type:'n'}
        ]

    events:
        'click .btn.save':  'save'
        'click .btn.reset': 'reset'
        'display-record':   'onRecordTrigger'

    reset: ->
        this.model = new Skr.Data.Customer

    save: ->
        Skr.View.SaveNotify(this, callback: (success,resp)->
        )

    onRecordTrigger: (ev)->
        ev.detail.ensureAssociations( 'billing_address', 'shipping_address', (model)->
            window.cust = model
        ,this)

Skr.View.Screens.CustomerMaint = Skr.View.Screen.extend(CustomerMaint)
