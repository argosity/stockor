require_relative "test_helper"

class PickTicketTest < Skr::TestCase

    def test_creation_from_so
        so = skr_sales_orders(:first)
        skr_sku_locs(:stringdefault).allocate_available_qty!
        assert_equal 1, so.lines.pickable.count
        pt = so.pick_tickets.build
        assert_equal 1, pt.lines.length
        assert_equal skr_skus(:string), pt.lines.first.sku
        assert_equal 1.42, pt.lines.first.price
        assert_saves pt
    end

    def test_canceling
        pt = skr_pick_tickets(:first)
        assert_equal 1, pt.lines.length
        refute pt.is_complete?, "Pick Ticket is complete when it shouldn't be"

        pt.mark_complete=true
        assert_saves pt
        # pt.is_complete.must_equal true
        # so_lines(:first_on_first).qty_picking.must_equal 0
    end

end
