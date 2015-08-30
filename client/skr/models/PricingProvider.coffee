Skr.Models.PricingProvider = {

    price: ( {uom, qty} ) ->
        qty ?= 1
        _.bigDecimal(uom.price).mul(qty)

}
