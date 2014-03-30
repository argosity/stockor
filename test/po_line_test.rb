require_relative 'test_helper'


class PoLineTest < Skr::TestCase


    # def test_creation
    #     po = skr_purchase_orders(:first)
    #     skuloc = skr_sku_locs(:hatdefault)
    #     pol = po.lines.build({
    #                                sku_loc: skuloc,
    #                                description: 'a test item',
    #                                uom_code: 'EA',
    #                                uom_size: 1,
    #                                price: 33.3
    #                           })
    #     assert_saves pol
    # end


    # def test_recieving
    #     line = skr_po_lines(:second_on_first)
    #     line.purchase_order.mark_saved!
    #     line.qty_received.must_equal 0
    #     line.qty_received = 1
    #     line.qty_received.must_equal 1
    #     assert_saves line
    #     line.reload
    #     line.qty_received.must_equal 0
    #     line.unlock_fields( :qty_received ) do
    #         line.qty_received = 33
    #         assert_saves line
    #     end
    #     line.reload
    #     line.qty_received.must_equal 33
    #     line.qty_received = 3
    #     assert_saves line
    #     line.reload
    #     line.qty_received.must_equal 33

    # end


    def test_mac_adjustment
        po = PurchaseOrder.new({ terms: skr_payment_terms(:cred_card),
                                 vendor: skr_vendors(:bigco),
                                 location: skr_locations(:default)  })
        po.mark_saved
        skuloc = skr_sku_locs(:hatdefault)

        pol = po.lines.build({
            sku_loc: skuloc,
            description: 'a test item',
            uom_code: 'CS',
            uom_size: 12,
            qty: 8,
            price: 33.3
        })
        assert_saves pol
        assert_equal '266.4', pol.total.to_s

        assert_equal '0.64' , skuloc.mac.to_s
        assert_equal 25, skuloc.qty

        v = Voucher.new({ :freight=>42.99, :purchase_order => po })
        line = v.lines.build({ :po_line => po.lines.first })
        assert_equal 8, line.qty
        skuloc = line.sku_loc
        assert_equal '266.4', line.total.to_s
        assert_equal '0.64', skuloc.mac.to_s

        assert_difference 'skuloc.qty', 96 do
            assert_saves line
        end
        assert_equal '2.775', ( line.total / line.ea_qty ).to_s
        # 96
        skuloc.mac.to_s.must_equal '2.3339'
    end

    # def test_empty_mac_adjustment
    #     po = purchase_orders(:unvouched)
    #     po.mark_saved!
    #     sl = sku_locs(:hatdefault)
    #     pol = po.lines.where({ sku_loc_id: sl }).first
    #     pol.qty_received.must_equal 0
    #     pol.qty.must_equal 1
    #     pol.price.must_equal 23.3
    #     sl.unlock_fields :mac, :qty do
    #         sl.qty = sl.mac = 0
    #         sl.save!
    #     end
    #     v = Voucher.new({ :freight=>42.99, :purchase_order => po })
    #     line = v.lines.build({ :po_line => pol })
    #     v.save!
    #     sl.reload
    #     sl.mac.must_equal 23.3
    #     sl.qty.must_equal 1
    # end

end
