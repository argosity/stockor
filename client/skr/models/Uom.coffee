class Skr.Models.Uom extends Skr.Models.Base

    props:
        id:    {type:"integer"}
        sku_id:{type:"integer"}
        price: {type:"bigdec",  required:true}
        size:  {type:"integer", default: 1}
        code:  {type:"string",  required:true, default: "EA"}
        weight:"bigdec"
        height:"bigdec"
        width: "bigdec"
        depth: "bigdec"

    derived:
        combined:
            deps: ['size', 'code'], fn: ->
                if @size is 1 then @code else "#{@code}/#{@size}"

        isDefault:
            deps: ['code', 'sku'], fn: ->
                @sku.default_uom_code is @code

    associations:
        sku: { model: "Sku" }

    eq: (other) ->
        other.size is @size and other.code is @code

    setDefault: ->
        this.sku.default_uom_code = @code

    constructor: ->
        super
        @sku.on('change:default_uom_code', ->
            @trigger('change', @, {})
            @unCacheDerived('total')
        , this)
