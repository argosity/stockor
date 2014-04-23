require_relative 'test_helper'

class PoLineTest < Skr::TestCase


    def test_creation
        po = skr_purchase_orders(:first)
        skuloc = skr_sku_locs(:hatdefault)
        pol = po.lines.build({ sku_loc: skuloc, description: 'a test item',
                               uom_code: 'EA', uom_size: 1, price: 33.3 })
        assert_saves pol
    end


    def test_recieving
        line = skr_po_lines(:second_on_first)
        line.qty_received = 1

        assert_saves line
        line.reload
        assert_equal 0, line.qty_received, "qty received saved, even though it should be locked"

        line.unlock_fields( :qty_received ) do
            line.qty_received = 33
            assert_saves line
        end
        line.reload
        assert_equal 33, line.qty_received
        line.qty_received = 3
        assert_saves line
        line.reload
        assert_equal 33, line.qty_received
    end


end
