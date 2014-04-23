require_relative 'test_helper'


class PorLineTest < Skr::TestCase


    def test_gl_postings
        po = skr_purchase_orders(:first)
        pol = skr_po_lines(:second_on_first)
        por = PoReceipt.new( freight: 42.99, purchase_order: po )
        line = por.lines.build({
            qty: 1,
            po_line: pol
        })
        assert_difference ->{ GlAccount.default_for(:inventory_receipts_clearing).trial_balance }, (line.price+42.99) * -1 do
            assert_difference ->{ line.sku_loc.sku.gl_asset_account.trial_balance }, line.price do
                assert_saves por
            end
        end
    end

    def test_recieving_qty
        po  = skr_purchase_orders(:first)
        pol = skr_po_lines(:second_on_first)
        po.mark_saved!
        por = PoReceipt.new({ purchase_order: po })
        line = por.lines.build({ po_line: pol })
        assert_difference ->{ line.sku_loc.reload.qty }, 1 do
            assert_saves por
            refute_empty line.sku_trans
            assert_equal 1, line.sku_trans.first.qty
            assert_equal line.sku_loc, line.sku_trans.first.sku_loc
            refute line.sku_trans.first.new_record?
        end
    end

    def test_mac_adjustments
        po  = skr_purchase_orders(:first)
        pol = skr_po_lines(:second_on_first)
        # po.mark_saved!
        por  = PoReceipt.new({ purchase_order: po })
        line = por.lines.build({ po_line: pol })
        assert_equal '0.12', line.sku_loc.mac.to_s
        assert_saves por
        assert_equal '2.9768', line.sku_loc.mac.to_s
    end

    def test_empty_mac_adjustment
        po = skr_purchase_orders(:unvouched)
        sl = skr_sku_locs(:hatdefault)
        pol = po.lines.where({ sku_loc_id: sl }).first
        assert_equal 0, pol.qty_received
        assert_equal 1, pol.qty
        assert_equal 23.3, pol.price
        sl.unlock_fields :mac, :qty do
            sl.qty = sl.mac = 0
            sl.save!
        end
        por = PoReceipt.new({ :freight=>42.99, :purchase_order => po })
        por.lines.build({ :po_line => pol })
        assert_saves por
        sl.reload
        sl.mac.must_equal 23.3
        sl.qty.must_equal 1
    end

    def test_prevents_over_receipt
        pol = skr_po_lines(:second_on_first)
        por = PoReceipt.new({ purchase_order: pol.purchase_order })
        line = por.lines.build({ po_line: pol })
        assert_difference ->{ line.sku_loc.reload.qty }, 1 do
            assert_saves por
            assert_equal 0, line.po_line.qty_unreceived
        end
        line = por.lines.build({ po_line: pol })
        assert line.invalid?, "Line should not be valid"
        assert line.errors[:qty]
    end


end
