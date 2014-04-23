require_relative 'test_helper'

class IaLineTest < Skr::TestCase


    def test_cost_adjustment
        ial = skr_ia_lines(:first)
        prior_mac = ial.sku_loc.mac
        ial.cost = 2332.33
        ial.cost_was_set = true
        ial.qty = -3
        refute_saves ial
        refute_nil ial.errors[:cost]

        ial.cost_was_set =false
        assert_saves ial

        assert_in_delta prior_mac * ial.uom_size, ial.cost
    end

    def test_setting_mac_cost
        ial = skr_ia_lines(:first)
        il = ial.sku_loc
        refute ial.is_applied?
        assert_in_delta 0.64, il.mac
        assert_nil ial.read_attribute('cost')
        assert_equal 6.4, ial.ledger_cost
        assert_saves ial
        adj = ial.inventory_adjustment
        adj.state_event='mark_applied'
        assert_saves ial#.inventory_adjustment.mark_applied!, "marking applied failed"
        ial.reload
        assert ial.cost, "Cost wasn't set from sku_loc"
        assert_in_delta 6.4, ial.cost
    end

    def test_no_mac_on_negative_qty
        ia = InventoryAdjustment.new({
                "reason_id" => skr_ia_reasons(:free).id,  "description"=>"A Groovy Adjustment",
                "lines_attributes"=>[ {
                        "qty"=>-10, "cost"=>3, "cost_was_set"=>true, "uom_code"=>"EA",
                        "uom_size"=>1, "sku_loc_id"=> skr_sku_locs(:hatdefault).id
                    } ],
                "location_id"=>skr_sku_locs(:hatdefault).location.id
            })
        refute_saves ia, 'lines.cost'
    end

    def test_adjusting_mac_cost
        ial = skr_ia_lines(:first)
        il = ial.sku_loc
        assert_equal 0.64, il.mac
        assert_equal  25,  il.qty
        assert_equal 16.0, il.onhand_mac_value
        ial.cost         = 10
        ial.qty          = 100
        ial.uom_size     = 2
        ial.cost_was_set = true
        assert_equal 1000, ial.total
        assert_saves ial
        assert ial.inventory_adjustment.mark_applied, "Failed to mark adj as applied"
        refute_nil ial.reload.sku_tran, "SkuTran wasn't created"
        il.reload
        assert_in_delta 4.515, il.mac # ( 16.0 + 1000 ) / ( 25 + 200 )
    end


end
