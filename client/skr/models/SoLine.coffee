class Skr.Models.SoLine extends Skr.Models.Base

    props:
        id:            {type:"integer", required:true}
        sales_order_id:{type:"integer"}
        sku_loc_id:    {type:"integer", required:true}
        price:         {type:"bigdec",  required:true}
        sku_code:      {type:"string",  required:true}
        description:   {type:"string",  required:true}
        uom_code:      {type:"string",  default: 'EA'}
        uom_size:      {type:"integer", default: 1}
        position:      {type:"integer", required:true}
        qty:           {type:"integer", required:true, "default":"0"}
        qty_allocated: {type:"integer", required:true, "default":"0"}
        qty_picking:   {type:"integer", required:true, "default":"0"}
        qty_invoiced:  {type:"integer", required:true, "default":"0"}
        qty_canceled:  {type:"integer", required:true, "default":"0"}
        is_revised:    {type:"boolean", required:true, default:false}

    session:
        sku_id:     {type: 'integer'}

    derived:
        total:  deps: ['qty', 'price'], fn: -> _.bigDecimal(@qty * @price)

    associations:
        sales_order: { model: "SalesOrder"  }
        sku_loc:     { model: "SkuLoc"      }
        sku:         { model: "Sku"         }
        uom:         { model: "Uom"         }
        location:    { model: "Location"    }
        pt_lines:    { collection: "PtLine" }

        uom_choices: { collection: "Uom", options: ->
            with: {for_sku_loc: @sku_loc_id}, query: {}

        }
        sku_choices: { collection: "Sku", options: ->
            with: {in_location: @sales_order.location_id}, query: {}
            include: ['sku_locs', 'uoms']
        }

    constructor: ->
        super
        @on("change:sku", @onSkuChange)
        @on("change:uom", @onUomChange)

        @sku_choices.options.with.in_location = @sales_order?.location_id
        @uom_choices.on("add", @onUomsLoad, this)
        @uom.size = @uom_size
        @uom.code = @uom_code

    onUomsLoad: ->
        uom = this.uom_choices.findWhere(size: @uom_size, code: @uom_code)
        this.uom.copyFrom(uom) if uom

    onSkuChange: ->
        return unless @sku
        sl = @sku.sku_locs.findWhere(sku_id: @sku.id)
        if sl
            @set(sku_loc: sl)
            @uom_choices.options.with.for_sku_loc = sl.id
        unless @sku.uoms.isEmpty()
            @uom_choices.reset(@sku.uoms.models)
            this.set(uom: @sku.uoms.findWhere(size: @uom_size) or @sku.uoms.first())

        @sku_code    = @sku.code if @sku.code
        @description = @sku.description if @sku.description

    onUomChange: (uom) ->
        if @uom_code isnt @uom.code or @uom_size isnt @uom.size
            @price = Skr.Models.PricingProvider.price(@)
        @uom_code = @uom.code
        @uom_size = @uom.size

    dataForSave: ->
        # so lines should never send associations
        super(excludeAssociations: true)
