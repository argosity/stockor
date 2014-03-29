require_relative 'test_helper'

class SkuTranTest < Skr::TestCase

    def test_origin
        ia = skr_inventory_adjustments(:first)
        assert ia.mark_applied, "failed to mark as applied"
        st = ia.lines.first.sku_tran
        assert st, "SkuTran wasn't created"
        assert_match( /^IA/, st.origin_description )
    end

    # def test_eq_qty
    #     st = SkuTran.new( qty: 8 )
    #     assert_equal 8, st.ea_qty

    #     st = SkuTran.new( uom: Skr::Uom.new( size: 10 ), qty: 8 )
    #     assert_equal 80, st.ea_qty
    # end

end
