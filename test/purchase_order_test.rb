require_relative 'test_helper'


class PurchaseOrderTest < Skr::TestCase

    def test_creation
        po = PurchaseOrder.new({
                                   terms: skr_payment_terms(:cred_card),
                                   vendor: skr_vendors(:bigco),
                                   location: skr_locations(:default)
                               })
        po.lines.build({
            sku_loc: skr_sku_locs(:hatdefault),
            description: 'a test item',
            uom_code: 'BX',
            uom_size: 10,
            price: 33.3
          })
        po.save!.must_equal true
    end


    # def test_state_transistions
    #     po = purchase_orders(:first)
    #     po.state.must_equal 'pending'
    #     po.valid_state_events.must_equal [ :mark_saved, :mark_received ]
    #     po.update_attributes( :state_event => :mark_saved )
    #     po.valid_state_events.must_equal [ :mark_transmitted, :mark_received ]

    #     po.state.must_equal 'saved'

    #     po.save.must_equal true
    # end

    # def test_date_time_default
    #     po = purchase_orders(:first)
    #     po.state.must_equal 'pending'
    #     po.update_attributes( :state_event => :mark_saved )
    #     po.save
    # end

    # def test_receiving
    #     po = purchase_orders(:first)
    #     po.mark_saved!
    #     v = Voucher.new({ :freight=>42.99, :purchase_order => po })
    #     po.lines.each do | pol|
    #         line = v.lines.build({ :po_line => pol } )
    #     end
    #     v.save.must_equal true
    #     line = po.lines.where({ sku_loc_id: sku_locs(:glovedefault)}).first
    #     line.qty_received.must_equal 1

    #     po.reload.state.must_equal 'received'
    # end

end
