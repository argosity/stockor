class Skr.Api.Models.Sku extends Skr.Api.Models.Base

    props:
        id:          {type:"integer"}
        code:        {type:"code"   }
        description: {type:"string" }
        price:       {type:"bigdec" }
        default_uom_code:    {type:"string" }

    derived:
        display_price: deps: ['price'], fn: ->
            Lanes.u.format.currency @price

    @findByCode: (code) ->
        sku = new Skr.Api.Models.Sku({code})
        sku.fetch(query: {code})
