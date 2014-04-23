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


    def test_gl_postings
        po    = skr_purchase_orders(:first)
        por   = PoReceipt.new( freight: 42.99, purchase_order: po )
        por.lines.build({ po_line: po.lines.first, qty: 1 })
        por.lines.build({ po_line: po.lines.last,  qty: 3 })

        gl = skr_gl_accounts(:inventory)

        # needs more nesting...
        assert_difference ->{ GlTransaction.count }, 1 do
            assert_difference ->{ GlPosting.count }, 3 do
                assert_difference ->{ gl.trial_balance }, 164.62 do
                    assert_saves por
                end
            end
        end
        glt = por.gl_transaction
        assert glt, "Receipt did not record a GlTransaction"
        assert_equal 1, glt.debits.count
        assert_equal( -207.61, glt.debits.first.amount )
        assert_equal skr_gl_accounts(:inv_recpt).default_number, glt.debits.first.account_number
        assert_equal 2, glt.credits.count
        assert_equal( 42.99, glt.credits.first.amount )
        assert_equal po.vendor.gl_freight_account.default_number, glt.credits.first.account_number
        assert_equal( 207.61-42.99, glt.credits.last.amount )
        assert_equal skr_gl_accounts(:inventory).default_number, glt.credits.last.account_number
    end

    def test_no_posting_if_save_failed
        po    = skr_purchase_orders(:first)
        por   = PoReceipt.new # <- No PO
        por.lines.build({ po_line: po.lines.first, qty: 1 })
        assert_difference ->{ GlTransaction.count }, 0 do
            assert_difference ->{ GlPosting.count }, 0 do
                refute_saves por
            end
        end
    end

    def test_failed_posting_raises
        po    = skr_purchase_orders(:first)
        por   = PoReceipt.new( freight: 42.99, purchase_order: po )
        por.lines.build({ po_line: po.lines.first, qty: 1 })
        assert_difference ->{ PoReceipt.count }, 0 do
            assert_difference ->{ GlTransaction.count }, 0 do
                assert_difference ->{ GlPosting.count }, 0 do
                    por.stub(:attributes_for_gl_transaction,{}) do
                        assert_raises Skr::InvalidGlTransaction do
                            refute_saves por
                        end
                    end
                end
            end
        end
    end

end
