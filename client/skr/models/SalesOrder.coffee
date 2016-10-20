class Skr.Models.SalesOrder extends Skr.Models.Base

    props:
        id:                 {type:"integer"}
        visible_id:         {type:"visible_id"}
        customer_id:        {type:"integer"}
        location_id:        {type:"integer", default: ->
            Skr.Models.Location.default.id
        }
        shipping_address_id:{type:"integer"}
        billing_address_id: {type:"integer"}
        terms_id:           {type:"integer"}
        order_date:         {type:"date", default: ->
            new Date
        }
        state:              {type:"integer"}
        is_revised:         {type:"boolean", default:false}
        hash_code:          {type:"string"}
        ship_partial:       {type:"boolean", default:false}
        form:               "string"
        po_num:             "string"
        notes:              {type: "string"}
        options:            "any"

    mixins: [ 'PrintSupport', 'HasVisibleId' ]

    # optional attributes from details view
    session:
        customer_code:      {type:"string"}
        customer_name:      {type:"string"}
        bill_addr_name:     {type:"string"}
        order_total:        {type:"bigdec"}
        num_lines:          {type:"integer"}

    derived:
        total: deps: ['order_total'], fn: ->
            @order_total or @lines.reduce( (t, l) ->
                t.plus(l.total)
            , _.bigDecimal(0))

    enums:
        state:
            open: 1
            complete: 5
            canceled: 9

    associations:
        customer:         { model: "Customer", required: true }
        location:         { model: "Location", required: true, default: ->
            Skr.Models.Location.all.get(@location_id) if @location_id
        }
        terms:            { model: "PaymentTerm"  }
        billing_address:  { model: "Address"      }
        shipping_address: { model: "Address"      }

        invoices:         { collection: "Invoice",    inverse: 'sales_order' }
        lines:            { collection: "SoLine",     inverse: 'sales_order', fk: 'sales_order_id',  }
        pick_tickets:     { collection: "PickTicket", inverse: 'sales_order' }

    events:
        'lines add remove change:total': 'onTotalChange'
        'change:customer': 'onCustomerChange'

    onTotalChange: ->
        @trigger('change', @, {})
        @unCacheDerived('total')
        @unset('order_total')

    onCustomerChange: ->
        return if @customer.isProxy or not @isNew()
        associations = ['billing_address', 'shipping_address']
        for attr in ['terms_id']
            @set(attr, @customer[attr])
        @customer.withAssociations(associations).then =>
            for name in associations
                @[name].set(
                    _.omit( @customer[name].serialize(), 'id' )
                )
