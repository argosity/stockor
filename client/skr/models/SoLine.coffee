class Skr.Models.SoLine extends Skr.Models.Base


    props:
        id:            {type:"integer", required:true}
        sales_order_id:{type:"integer", required:true}
        sku_loc_id:    {type:"integer", required:true}
        price:         {type:"bigdec", required:true}
        sku_code:      {type:"string", required:true}
        description:   {type:"string", required:true}
        uom_code:      {type:"string", required:true}
        uom_size:      {type:"integer", required:true}
        position:      {type:"integer", required:true}
        qty:           {type:"integer", required:true, "default":"0"}
        qty_allocated: {type:"integer", required:true, "default":"0"}
        qty_picking:   {type:"integer", required:true, "default":"0"}
        qty_invoiced:  {type:"integer", required:true, "default":"0"}
        qty_canceled:  {type:"integer", required:true, "default":"0"}
        is_revised:    {type:"boolean", required:true, default:false}

    session:
        uom: { type: 'state' }
        line_total: {type: 'bigdec'}

    derived:
        sku_id: deps: ['sku_loc_id'], fn: -> @sku_loc.sku_id

        total: deps: ['qty', 'price'], fn: ->
            _.bigDecimal(@qty * @price)

    associations:
        sales_order: { model: "SalesOrder"  }
        sku_loc:     { model: "SkuLoc"      }
        location:    { model: "Location"    }
        pt_lines:    { collection: "PtLine" }

        uom_choices:
            collection: "Uom", fk: 'sku_loc_id', options: ->
                parent: null # important
                with: {for_sku_loc: @sku_loc_id}, query: {}


    constructor: ->
        super
        @on("change:sku_loc", @onSkuChange)
        @on("change:uom",     @onUomChange)
        if @uom
            @onUomChange()
        else
            @uom = new Skr.Models.Uom(id: @sku_loc_id, size: @uom_size, code: @uom_code, price: @price)

    onSkuChange: (sl) ->
        @sku_code    = sl.sku.code
        @description = sl.sku.description
        @uom_choices.options.with.for_sku_loc = sl.id

    onUomChange: ->
        @uom_code = @uom.code
        @uom_size = @uom.size
        @price = Skr.Models.PricingProvider.price(@, @uom)
