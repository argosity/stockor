class Skr.Models.SalesOrder extends Skr.Models.Base

    props:
        id:                 {type:"integer", required:true}
        visible_id:         {type:"integer", required:true}
        customer_id:        {type:"integer", required:true}
        location_id:        {type:"integer", required:true, default: ->
            Skr.Models.Location.default()?.id
        }
        shipping_address_id:{type:"integer", required:true}
        billing_address_id: {type:"integer", required:true}
        terms_id:           {type:"integer", required:true}
        order_date:         {type:"any", required:true}
        state:              {type:"integer"}
        is_revised:         {type:"boolean", required:true, default:false}
        hash_code:          {type:"string", required:true}
        ship_partial:       {type:"boolean", required:true, default:false}
        po_num:             "string"
        notes:              "string"
        options:            "any"

    # optional from details view
    session:
        customer_code:      {type:"string"}
        order_total:        {type:"bigdec"}

    derived:
        total: deps: ['order_total', 'lines' ], fn: ->
            @order_total or @lines.reduce( (t, l) ->
                t.plus(l.total)
            , _.bigDecimal(0))

    enums:
        state:
            open: 1
            complete: 5
            canceled: 9

    associations:
        customer:         { model: "Customer" }
        location:         { model: "Location", default: ->
            Skr.Models.Location.fetchById(@location_id) if @location_id
        }
        terms:            { model: "PaymentTerm"  }
        billing_address:  { model: "Address"      }
        shipping_address: { model: "Address"      }
        skus:             { collection: "Sku"     }
        invoices:         { collection: "Invoice" }
        lines:            { collection: "SoLine", fk: 'sales_order_id' }
        pick_tickets:     { collection: "PickTicket" }

    constructor: ->
        super
        @on("change:customer", @onCustomerChange)
        @listenTo @lines, 'change:total', ->
            @trigger('change', @, {})
            delete this._cache.total
            @unset('order_total')

    onCustomerChange: ->
        return unless @isNew()
        associations = ['billing_address', 'shipping_address']
        @customer.withAssociations(associations).then( =>
            for name in associations
                this[name].copyFrom(@customer[name])
        )
