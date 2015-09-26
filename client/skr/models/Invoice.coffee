class Skr.Models.Invoice extends Skr.Models.Base


    props:
        id:                 {type:"integer", required:true}
        visible_id:         {type:"integer", required:true}
        terms_id:           {type:"integer", required:true}
        customer_id:        {type:"integer", required:true}
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
            @order_total or @lines.reduce( (t, l) ->
                t.plus(l.total)
            , _.bigDecimal(0))

    enums:
        state:
            open: 1
            paid: 5
            partial: 9

    associations:
        sales_order:      { model: "SalesOrder" }
        customer:         { model: "Customer" }
        location:         { model: "Location" }
        terms:            { model: "PaymentTerm" }
        pick_ticket:      { model: "PickTicket" }
        billing_address:  { model: "Address" }
        shipping_address: { model: "Address" }
        gl_transactions:  { collection: "GlTransaction" }
        lines:            { collection: "InvLine" }


    constructor: ->
        super
        @on("change:customer", @onCustomerChange)
        @lines.on('change:total', ->
            @trigger('change', @, {})
            @unCacheDerived('total')
            @unset('order_total')
        , this)

    onCustomerChange: ->
        return unless @isNew()
        @copyAssociationsFrom( @customer, 'billing_address', 'shipping_address')

    setFromSalesOrder: (so) ->
        debugger
        @copyAssociationsFrom( so,
            'customer', 'location', 'billing_address', 'shipping_address'
        ).then =>
#            @sales_order.copyFrom(so)
            @notes ||= @sales_order.notes
            so.lines.fetch(with: ['sku_code']).then =>
                @lines.copyFrom(so.lines)

    copyAssociationsFrom: ( model, associations... ) ->
        new _.Promise (res, rej) =>
            model.withAssociations(associations).then =>
                for name in associations
                    @[name].copyFrom(model[name])
                res(@)
