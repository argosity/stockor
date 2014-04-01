require_relative 'test_helper'

class SkuLocTest < Skr::TestCase

    def test_qty_locked
        sl = skr_sku_locs(:hatdefault)
        sl.qty=800
        sl.save!.must_equal true
        sl.reload.qty.must_equal 25
    end


    def test_allocations
        sol = skr_so_lines(:first_string)
        sl = sol.sku_loc

        assert_equal 33, sl.qty_available
        refute sol.is_fully_allocated?, "test line is already allocated"
        sl.allocate_available_qty!
        sol.reload # <- needed because sku_loc allocations uses a scope
        assert sol.is_fully_allocated?, "failed to allocate test line"
        assert_equal 27, sl.reload.qty_available

        sol.update_attributes :qty_allocated => 0
        assert_equal 33, sl.reload.qty_available
    end

    def test_qty_event
        sl = skr_sku_locs(:hatdefault)
        assert_event_fires( SkuLoc, :qty_change ) do
            # NEVER do this directly - it will throw the MAC
            # and GL out off balance.  Instead use SkuTran
            sl.unlock_fields( :qty ) do
                sl.adjust_qty( 10 )
                assert_saves sl
            end
        end
        assert_equal [sl], last_event_results
    end

    def test_picking
        sl = skr_sku_locs(:stringdefault)
        sol = sl.so_lines.where( sku_loc: sl ).first
        sl.allocate_available_qty!
        pt = sol.sales_order.pick_tickets.build
        assert_difference 'sl.reload.qty_picking', 6 do
            assert_saves pt
        end
    end
end
