require_relative 'test_helper'


class PoReceiptTest < Skr::TestCase

    def test_posting_freight
        po    = skr_purchase_orders(:first)
        por   = PoReceipt.new( freight: 42.99, purchase_order: po )
        assert_difference ->{ por.vendor.gl_freight_account.trial_balance }, 42.99 do
            assert_saves por
        end
    end

    def test_allocations
        po = skr_purchase_orders(:first)

        poline = po.lines.last
        qty = poline.qty_unreceived
        sl=poline.sku_loc
        sol = skr_so_lines(:picking_glove)
        assert_equal 2, sl.so_lines.count

        por = PoReceipt.new( freight: 42.99, purchase_order: po )
        por.lines.build( po_line: poline, qty: qty, auto_allocate: true )
        assert_equal 19, sol.qty-sol.qty_allocated
        assert_difference( 'sl.qty_allocated', 19 ) do
            assert_saves por
        end
        assert_equal qty, poline.reload.qty_received
    end

end
