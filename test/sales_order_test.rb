require_relative 'test_helper'


class SalesOrderTest < Skr::TestCase

    def test_date_default
        so = SalesOrder.new
        assert_equal Date.today, so.order_date
    end

    def test_updating_location
        so = skr_sales_orders(:first)
        so.location = skr_locations(:amazon)
        assert_not so.save, "SO saved with invalid location"
        assert_equal "Location AMAZON does not have skus STRING", so.errors.full_messages.first
        sku = skr_skus(:string)
        sl = sku.sku_locs.find_or_create_for( so.location )
        assert_saves so
        assert sl
    end


    def test_creating
        customer = skr_customers(:joe)
        so = SalesOrder.new( customer: customer )
        Sku.where( code: ['HAT','STRING'] ).each do | sku |
            so.lines.build(
              sku_loc: sku.sku_locs.default
            )
        end
        assert_saves so
    end


    def test_allocation_counts
        sol = skr_so_lines(:first_string)
        sol.qty_allocated=1
        assert_saves sol
        so = SalesOrder.allocated.where({ :id=>skr_sales_orders(:first) }).first
        assert so, "SO wasn't found"
        assert_equal 1,so.number_of_lines_allocated
        assert_equal 0,so.number_of_lines_fully_allocated
    end

    def test_picking
        so = skr_sales_orders(:first)
        skr_sku_locs(:stringdefault).allocate_available_qty!
        assert_equal 1, so.lines.pickable.count
        assert_equal 2, so.lines.pickable.first.qty_allocated
        pt = so.pick_tickets.build
        pt.save!
        assert_equal 1, pt.lines.count
        so.reload
        assert_equal 0, so.lines.pickable.count
    end


    def test_cancelling
        so = skr_sales_orders(:picking)
        assert_equal 'open', so.state
        assert_equal 5, so.lines.first.qty_picking
        refute so.pick_tickets.first.is_complete
        assert so.mark_canceled!
        assert_equal 0, so.lines.first.qty_picking
        assert so.pick_tickets.first.is_complete
    end

    def test_sales_history
        stats = SalesOrder.sales_history( 5 )
        assert_equal 5, stats.count
        assert_equal ["3","5","120.02"], stats[0][2..-1]
    end

end
