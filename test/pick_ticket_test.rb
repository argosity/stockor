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
        pt.save!.must_equal true
    end

    # def test_lines_from_so
    #     so = sales_orders(:first)
    #     so.lines.allocated.length.must_equal 1
    #     pt = so.pick_tickets.build
    #     pt.lines.length.must_equal 1
    # end

    # def test_overcreate_prevented
    #     so = sales_orders(:first)
    #     so.lines.allocated.length.must_equal 1

    #     pt = so.pick_tickets.build
    #     so.lines.first.pickable_qty.must_equal 20

    #     pt.lines.length.must_equal 1
    #     pt.lines.first.qty.must_equal 20
    #     pt.save!

    #     sol = so_lines(:first_on_first)
    #     sol.pt_lines.length.must_equal 1
    #     sol.pt_lines.sum(:qty).must_equal 20

    #     sol.pickable_qty.must_equal 0

    #     pt = so.pick_tickets.build
    #     pt.lines.length.must_equal 0
    # end


    # def test_canceling
    #     pt = pick_tickets(:first)
    #     pt.lines.length.must_equal 1
    #     pt.is_complete.must_equal false

    #     pt.mark_complete=true
    #     pt.save

    #     pt.is_complete.must_equal true
    #     so_lines(:first_on_first).qty_picking.must_equal 0
    # end

    # def test_invoicing
    #     pt = pick_tickets(:first)
    #     pt.lines.each{|l| l.qty_to_ship = l.qty }
    #     inv = Invoice.new
    #     inv.pick_ticket = pt #pt.invoice = inv
    #     inv.save!.must_equal true
    # end

end
