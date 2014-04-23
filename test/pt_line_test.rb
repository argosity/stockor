require_relative "test_helper"

class PtLineTest < Skr::TestCase

    def test_invoicing
        pt = skr_pick_tickets(:first)
        ptl = pt.lines.first

        assert_equal 0, ptl.qty_invoiced

        inv = Invoice.new({ :pick_ticket=> pt })
        inv.lines.from_pick_ticket( pt )
        assert_saves inv

        assert_equal inv.lines.length, pt.lines.length

        refute_nil inv.lines.first.pt_line
        assert_equal ptl, inv.lines.first.pt_line

        assert_equal ptl.reload.qty_invoiced, inv.lines.first.qty
    end

    def test_bin_is_assigned
        so = skr_sales_orders(:first)
        skr_sku_locs(:stringdefault).allocate_available_qty!
        assert_equal 1, so.lines.pickable.count
        pt = so.pick_tickets.build
        assert_saves pt
        assert_equal skr_sku_locs(:stringdefault).bin, pt.lines.first.bin
    end

end
