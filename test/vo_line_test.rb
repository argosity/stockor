require_relative 'test_helper'


class VoucherLineTest < Skr::TestCase

    fixtures :all

    def test_gl_postings
        po = skr_purchase_orders(:first)
        pol = skr_po_lines(:second_on_first)
        vouch = Voucher.new( freight: 42.99, purchase_order: po )
        vouch.lines.build({
            qty: 1,
            po_line: pol
          })
        assert_difference ->{ pol.sku_loc.sku.gl_asset_account.trial_balance }, pol.price do
            assert_saves vouch
        end
    end

    def test_recieving
        po = skr_purchase_orders(:first)
        po.mark_saved!
        v = Voucher.new({ :freight=>42.99, :purchase_order => po })
        poline = po.lines.where({ sku_loc_id: skr_sku_locs(:glovedefault).id }).first
        assert_equal 1, poline.qty
        assert_equal 0, poline.qty_received
        line = v.lines.build({ :po_line => poline, :qty=>poline.qty })
        assert_saves line
        assert_equal 1, poline.reload.qty_received
    end

    # def test_over_receipts
    #     po = purchase_orders(:first)
    #     po.mark_saved!
    #     v = Voucher.new({ :freight=>42.99, :purchase_order => po })
    #     line = v.lines.build({ :po_line => po.lines.first })
    #     line.qty = 10000
    #     line.save.must_equal false
    #     line.errors[:qty].wont_be_nil
    # end

    # def test_adjusts_mac_correctly
    #     po = purchase_orders(:first)
    #     po.mark_saved!
    #     v = Voucher.new({ :freight=>42.99, :purchase_order => po })
    #     v.save
    #     pol = po_lines(:second_on_first)
    #     line = v.lines.build({ :po_line => pol, :price=> 100.00, :qty=>1 })
    #     line.qty.must_equal 1
    #     sku_loc = pol.sku_loc
    #     sku_loc.mac.to_s.must_equal '10.22'
    #     sku_loc.qty.must_equal 42
    #     sku_loc.onhand_mac_value.to_s.must_equal '429.24'
    #     lambda {
    #         line.save!
    #         sku_loc.reload
    #         sku_loc.qty.must_equal 43
    #         sku_loc.mac.to_s.must_equal '12.3079'

    #     }.must_change sku_loc, :mac, 2.0879
    # end

    # def test_adjusting_mac_when_voucher_cost_is_edited
    #     vl = voucher_lines(:first)
    #     vl.price.must_equal 1.42
    #     sku_loc = SkuLoc.where( { location_id: vl.location, sku_id: vl.sku }).first
    #     sku_loc.mac.to_s.must_equal '0.64'
    #     vl.sku_code.must_equal 'HAT'

    #     vl.price = 10.00
    #     lambda {
    #         vl.save.must_equal true
    #         sku_loc.reload
    #         sku_loc.mac.to_s.must_equal '1.6696'
    #     }.must_change sku_loc, :mac, 1.0296
    # end

    # def test gl_posting
    #     acct = Tenant.current.gl_inventory_receipt_clearing_account
    #     po = purchase_orders(:first)
    #     po.mark_saved!
    #     v = Voucher.new({ :freight=>42.99, :purchase_order => po })
    #     old_balance = acct.masked_balance
    #     v.save.must_equal true
    #     po.lines.each do | poline |
    #         vline = v.lines.build({ :po_line => poline })
    #         vline.save!
    #     end
    #     acct.masked_balance.must_equal old_balance - v.total
    # end

    # def test_allocations
    #     po = purchase_orders(:first)

    #     poline = po.lines.last
    #     qty = poline.qty_unreceived
    #     sl=poline.sku_loc
    #     sol = so_lines(:picking_glove)
    #     assert_equal 2, sl.so_lines.count

    #     v = Voucher.new({ :freight=>42.99, :purchase_order => po })
    #     line = v.lines.build({ :po_line => poline, :qty=>qty, :auto_allocate=>true })

    #     assert_difference( 'sl.qty_allocated', sol.qty-sol.qty_allocated ) do
    #         line.save.must_equal true
    #     end
    #     assert_equal qty, poline.reload.qty_received

    # end
end
