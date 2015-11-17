ASSOCIATIONS =
    uom_choices: { collection: "Uom", options: ->
        with: {for_sku_loc: @sku_loc_id}, query: {}

    }
    sku_choices: { collection: "Sku", options: ->
        with: {in_location: @location_id}, query: {}
        include: ['sku_locs', 'uoms']
    }
    sku:         { model: "Sku"    }
    uom:         { model: "Uom"    }
    sku_loc:     { model: "SkuLoc" }


DERIVED =
    total:  deps: ['qty', 'price'], fn: -> _.bigDecimal(@qty * @price)

Skr.Models.Mixins.SkuLine = {

    included: (klass) ->
        _.extend( klass::derived ||= {},      DERIVED)
        _.extend( klass::associations ||= {}, ASSOCIATIONS)

    initialize: ->
        @on('change:sku', @onSkuChange)
        @on('change:uom', @onUomChange)
        @on('change:location_id', @onLocationChange)
        @uom_choices.on("add", @onUomsLoad, this)
        @uom.size = @uom_size
        @uom.code = @uom_code

    onLocationChange: ->
        if @location_id
            @sku_choices.options.with.in_location = @location_id

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
            uom = @sku.uoms.findWhere(size: @uom_size) or @sku.uoms.first()
            this.set(uom: uom)

        @sku_code    = @sku.code if @sku.code
        @description = @sku.description if @sku.description

    onUomChange: (uom) ->
        unless @unsavedAttributes().price and @price.gt(0)
            @price = Skr.Models.PricingProvider.price({uom})
        @uom_code = uom.code
        @uom_size = uom.size
}
