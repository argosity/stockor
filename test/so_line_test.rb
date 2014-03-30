require_relative 'test_helper'

class SoLineTest < Skr::TestCase


    def test_creation
        sol = SoLine.new({
            sales_order:  skr_sales_orders(:first),
            sku_loc:      skr_sku_locs(:hatdefault),
            description:'A Test', price: 12.42
          })
        sol.uom = skr_uoms('HATEA')
        sol.save.must_equal true
    end

    # def test_postition
    #     first = so_lines(:first_on_first)
    #     skuloc = sku_locs(:hatdefault)
    #     sol = SoLine.new({ sales_order: first.sales_order, sku_loc: skuloc, description:'A Test', price: 12.42 })
    #     sol.uom = uoms('0838EA')
    #     sol.save.must_equal true
    #     sol.position.must_equal 2
    # end

    # def test_allocation
    #     so = SalesOrder.new({ customer: customers(:stitt), location: locations(:default), terms: terms(:default_cred_card) })
    #     sku_loc = sku_locs(:hatdefault)
    #     assert_equal 20, sku_loc.qty_available
    #     so.lines.build({ qty: 2, :price=>2.22, sku_loc: sku_loc })
    #     lambda {
    #         so.save!.must_equal true
    #     }.must_change sku_loc, :qty_allocated, 2

    # end

    # def test_cancel_picking
    #     so = SalesOrder.new({ customer: customers(:stitt), location: locations(:default), terms: terms(:default_cred_card) })
    #     sku_loc = sku_locs(:hatdefault)
    #     sol = so.lines.build({  qty: 2,   sku_loc: sku_loc, :price=>2.22  })
    #     so.save!
    #     pt = so.pick_tickets.build
    #     pt.save!
    #     ptl = sol.pt_lines.first
    #     assert_equal 2, pt.lines.count
    #     assert_equal 2, ptl.qty
    #     assert ! ptl.is_complete?
    #     sol.qty_allocated = 1
    #     sol.save.must_equal true

    #     assert ptl.reload.is_complete?
    #     refute pt.reload.is_complete? # only cancel the one line
    # end

    # def test_backorders
    #     so = sales_orders(:first)
    #     assert_equal 1, so.lines.count
    #     assert_equal 1, so.lines.unallocated.count
    #     line = so.lines.first
    #     line.update_attributes :qty_allocated => line.qty
    #     assert_equal 0, so.lines.unallocated.count

    #     line = sales_orders(:picking).lines.unallocated.first
    #     assert line
    #     line.update_attributes :qty_allocated => line.qty, :qty_picking=>line.qty
    #     assert_equal 1, line = sales_orders(:picking).lines.unallocated.count
    #     assert_equal 0, sales_orders(:complete).lines.unallocated.count
    # end
end
