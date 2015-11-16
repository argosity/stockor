class Skr.Models.Invoice extends Skr.Models.Base


    props:
        id:                 {type:"integer", required:true}
        visible_id:         {type:"integer", required:true}
        terms_id:           {type:"integer", required:true}
        customer_id:        {type:"integer", required:true, default: ->
            Skr.Models.Location.default()?.id
        }
        location_id:        {type:"integer", required:true}
        sales_order_id:     "integer"
        pick_ticket_id:     "integer"
        shipping_address_id:{type:"integer", required:true}
        billing_address_id: {type:"integer", required:true}
        amount_paid:        {type:"bigdec", required:true, "default":"0.0"}
        state:              {type:"string", required:true}
        hash_code:          {type:"string", required:true}
        invoice_date:       {type:"any", required:true}
        notes:              "string"
        po_num:             "string"
        options:            "any"

    mixins: [ Skr.Models.Mixins.PrintSupport ]
    # optional attributes from details view
    session:
        customer_code: {type:"string"}
        invoice_total: {type:"bigdec"}

    derived:
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
        customer:         { model: "Customer",    readOnly:true }
        location:         { model: "Location",    readOnly:true, default: ->
            Skr.Models.Location.fetchById(@location_id) if @location_id
        }
        terms:            { model: "PaymentTerm", readOnly:true }
        pick_ticket:      { model: "PickTicket",  readOnly:true }
        lines:            { collection: "InvLine", inverse: 'invoice'  }
        gl_transactions:  { collection: "GlTransaction", readOnly:true }

    constructor: ->
        super
        @lines.on('change:total', @onChangeTotal, this)
        @on('change:customer', @onSetCustomer)

    onChangeTotal: ->
        @trigger('change', @, {})
        @unCacheDerived('total')
        @unset('invoice_total')

    onSetCustomer: (newCustomer) ->
        return if not newCustomer or newCustomer.isNew()
        @copyAssociationsFrom( newCustomer, 'billing_address', 'shipping_address')

    setFromSalesOrder: (so) ->
        @sales_order_id = so.id
        @sales_order.copyFrom(so)

        @copyAssociationsFrom( so,
            'location', 'customer', 'location', 'billing_address', 'shipping_address'
        ).then =>
            @notes ||= @sales_order.notes
            so.lines.fetch(with: ['sku_code'], include: ['sku']).then =>
                @lines.copyFrom(so.lines)

    copyAssociationsFrom: ( model, associations... ) ->
        new _.Promise (res, rej) =>
            model.withAssociations(associations).then =>
                for name in associations
                    @[name].copyFrom(model[name])
                res(@)

    dataForSave: ->
        # only send some associations
        super(onlyAssociations: ['lines', 'billing_address', 'shipping_address'])
