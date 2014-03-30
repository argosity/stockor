require_relative 'test_helper'

class SkuTest < Skr::TestCase

    def test_locations
        sku = skr_skus(:string)
        assert_equal 2, sku.sku_locs.length
        assert sku.sku_locs.find_or_create_for( skr_locations(:surplus) )
        loc = skr_locations(:amazon)
        refute sku.sku_locs.where( location: loc ).first
        assert sku.sku_locs.find_or_create_for( loc )
    end

    def test_vendors
        sku = skr_skus(:glove)
        assert sku.sku_vendors.default
        assert_equal skr_sku_vendors(:glove_bigco), sku.sku_vendors.default
    end

    def test_uoms
        sku = skr_skus(:hat)
        assert sku.uoms.default
    end


    def test_auto_location_creation
        sku=Sku.new({ :code=>'Test', :description=>'A Long Description' })
        sku.sku_vendors.build({
                part_code: 'TESTHAT', vendor: skr_vendors(:bigco),
                list_price: 0.42, cost: 0.34, uom_size: 1, uom_code: 'EA' })
        sku.default_uom_code  = 'EA'
        assert_empty sku.sku_locs
        assert_saves sku
        refute_empty sku.sku_locs
    end

    def test_scopes
        assert_equal skr_skus(:string), Sku.with_vendor_part_code( 'STRINGBALL' ).first
        assert Sku.in_location( skr_locations(:amazon) ).where( code: 'HAT' ).first
        sku=Sku.with_qty_details.where( code: 'HAT' ).first
        assert_equal 25, sku.qty_on_orders
        assert_equal 35, sku.qty_on_hand
        assert_equal 4,  sku.qty_incoming
    end
end
