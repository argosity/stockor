class Skr.Models.Invoice extends Skr.Models.Base


    props:
        id:                 {type:"integer"}
        visible_id:         {type:"visible_id"}
        terms_id:           {type:"integer"}
        customer_id:        {type:"integer"}
        location_id:        {type:"integer", default: ->
            Skr.Models.Location.default.id
        }
        sales_order_id:     "integer"
        pick_ticket_id:     "integer"
        shipping_address_id:{type:"integer"}
        billing_address_id: {type:"integer"}
        amount_paid:        {type:"bigdec", "default":"0"}
        state:              {type:"string"}
        hash_code:          {type:"string"}
        invoice_date:       {type:"date", default: ->
            new Date
        }
        notes:              "string"
        po_num:             "string"
        form:               "string"
        options:            "any"

    mixins: [ 'HasVisibleId', 'PrintSupport' ]

    # optional attributes from details view
    session:
        customer_code: {type:"string"}
        invoice_total: {type:"bigdec"}

    derived:
        prev_amount_paid: deps:['updated_at'], fn: -> @amount_paid
        open_amount: deps: ['total', 'amount_paid'], fn: ->
            @total.minus(@amount_paid)
        total: deps: ['invoice_total'], fn: ->
            @invoice_total or @lines.reduce( (t, l) ->
                t.plus(l.total)
            , _.bigDecimal(0))

    enums:
        state:
            open: 1
            paid: 5
            partial: 9

    associations:
        billing_address:  { model: "Address" }
        shipping_address: { model: "Address" }
        sales_order:      { model: "SalesOrder",  readOnly:true }
        customer:         { model: "Customer",    required: true, readOnly:true }
        location:         { model: "Location",    required: true, readOnly:true, default: ->
            Skr.Models.Location.fetchById(@location_id) if @location_id
        }
        terms:            { model: "PaymentTerm", required: true, readOnly:true }
        pick_ticket:      { model: "PickTicket",  readOnly:true }
        lines:            { collection: "InvLine", inverse: 'invoice'  }
        gl_transactions:  { collection: "GlTransaction", readOnly:true }

    events:
        'change:customer': 'onSetCustomer'
        'lines change:total': 'onChangeTotal'

    onChangeTotal: ->
        @trigger('change', @, {})
        @unCacheDerived('total')
        @unset('invoice_total')

    onSetCustomer: (newCustomer) ->
        return if not newCustomer or newCustomer.isNew()
        @copyAssociationsFrom( newCustomer, 'billing_address', 'shipping_address')

    setFromSalesOrder: (so) ->
        @sales_order_id = so.id
        for attr in ['customer_code', 'po_num', 'notes', 'terms_id', 'form']
            @set(attr, so[attr])

        @associations.replace(@, 'sales_order', @sales_order)
        @copyAssociationsFrom(so,
            'customer', 'billing_address', 'shipping_address'
        ).then =>
            so.lines.fetch(with: ['sku_code'], include: ['sku']).then =>
                @lines.reset so.lines.map(Skr.Models.InvLine.fromSoLine)
                @onChangeTotal()
                @trigger('change', @, {})

    copyAssociationsFrom: ( model, associations... ) ->
        new _.Promise (res, rej) =>
            model.withAssociations(associations).then =>
                for name in associations
                    @associations.replace(@, name, model[name])
                res(@)

    dataForSave: ->
        # only send some associations
        super(onlyAssociations: ['lines', 'billing_address', 'shipping_address'])

    isPaidInFull: ->
        @state == 'paid'
