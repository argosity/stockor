require_relative 'test_helper'

class IaLineTest < Skr::TestCase


    # def test_cost_adjustment
    #     ial = skr_ia_lines(:first)
    #     prior_mac = ial.sku_loc.mac
    #     ial.cost = 2332.33
    #     ial.cost_was_set = true
    #     ial.qty = -3
    #     ial.save.must_equal false
    #     ial.errors[:cost].wont_be_nil

    #     ial.cost_was_set =false
    #     ial.save.must_equal true

    #     ial.cost.must_be_within_delta prior_mac * ial.uom_size
    # end

    # def test_setting_mac_cost
    #     ial = skr_ia_lines(:first)
    #     il = ial.sku_loc
    #     ial.is_applied?.must_equal false
    #     il.mac.must_equal 0.64
    #     ial.read_attribute('cost').must_be_nil
    #     ial.ledger_cost.must_equal 6.4 # il.mac * ial.uom_size
    #     assert ial.save!, "Saving line failed"
    #     adj = ial.inventory_adjustment
    #     adj.state_event='mark_applied'
    #     assert ial.inventory_adjustment.mark_applied!, "marking applied failed"
    #     ial.reload
    #     assert ial.cost, "Cost wasn't set from sku_loc"
    #     ial.cost.must_be_within_delta 6.4
    # end

    def test_adjusting_mac_cost
        ial = skr_ia_lines(:first)
        il = ial.sku_loc
        il.mac.must_equal 0.64
        il.qty.must_equal 25
        il.onhand_mac_value.must_equal 16.0
        ial.cost         = 10
        ial.qty          = 100
        ial.uom_size     = 2
        ial.cost_was_set = true
        ial.total.must_equal 1000
        ial.save.must_equal true
        assert ial.inventory_adjustment.mark_applied, "Failed to mark adj as applied"
        ial.sku_tran.wont_be_nil
        il.reload
        il.mac.must_be_within_delta 4.515 # ( 16.0 + 1000 ) / ( 25 + 200 )
    end


end
