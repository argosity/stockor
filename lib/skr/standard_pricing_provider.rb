module Skr

    class StandardPricingProvider

        # The default implementation returns the price for the given UOM
        # Custom implementations will return from a pricing library
        # @return [BigDecimal] the "standard" price for the SKU
        def self.price( sku_loc: nil, customer: nil, uom: nil, qty: 1 )
            sku_loc.sku.uoms.with_code( uom.code ).price
        end

    end
end

