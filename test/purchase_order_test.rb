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
        assert_saves po
    end


    def test_state_transistions
        po = skr_purchase_orders(:first)
        po.state.must_equal 'pending'
        po.valid_state_events.must_equal [ :mark_saved, :mark_received ]
        po.update_attributes( :state_event => :mark_saved )
        po.valid_state_events.must_equal [ :mark_transmitted, :mark_received ]
        po.state.must_equal 'saved'
        assert_saves po
    end


    def test_receiving
        po = skr_purchase_orders(:first)
        po.mark_saved!
        por   = PoReceipt.new( purchase_order: po )
        po.lines.each do | pol|
            next if pol.qty_unreceived.zero?
            por.lines.build({ :po_line => pol })
        end
        assert_saves por
        assert_equal 'received', po.state
    end

end
