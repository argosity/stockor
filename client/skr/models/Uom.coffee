class Skr.Models.Uom extends Skr.Models.Base


    props:
        id:    {type:"integer", required:true}
        sku_id:{type:"integer", required:true}
        price: {type:"bigdec", required:true}
        size:  {type:"integer", required:true, "default":1}
        code:  {type:"string", required:true, "default":"EA"}
        weight:"bigdec"
        height:"bigdec"
        width: "bigdec"
        depth: "bigdec"

    derived:
        combined:
            deps: ['size', 'code'], fn: ->
                if @size is 1 then @code else "#{@code}/#{@size}"

    associations:
        sku: { model: "Sku" }
