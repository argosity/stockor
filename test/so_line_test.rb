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

    def test_picking_qty
        sol = skr_so_lines(:first_string)
        sol.sku_loc.allocate_available_qty!
        pt = sol.sales_order.pick_tickets.build
        assert_saves pt
        assert_equal 2, sol.reload.qty_picking
    end

    def test_scopes
        sol = skr_so_lines(:first_string)
        sol.sku_loc.allocate_available_qty!
        assert_equal 3, SoLine.pending.count
        assert_equal 3, SoLine.allocated.count
        assert_equal 2, SoLine.unallocated.count
        assert_equal 1, SoLine.pickable.count
    end

    def test_allocation
        so = SalesOrder.new({ customer: skr_customers(:stitt) })
        sku_loc = skr_sku_locs(:hatdefault)
        assert_equal 20, sku_loc.qty_available
        so.lines.build({ qty: 2, :price=>2.22, sku_loc: sku_loc })
        assert_difference 'sku_loc.reload.qty_allocated',2 do
            assert_saves so
        end

    end

    def test_backorders
        so = skr_sales_orders(:first)
        assert_equal 1, so.lines.count
        assert_equal 1, so.lines.unallocated.count
        line = so.lines.first
        line.update_attributes :qty_allocated => line.qty
        assert_equal 0, so.lines.unallocated.count

        line = skr_sales_orders(:picking).lines.unallocated.first
        assert line
        line.update_attributes :qty_allocated => line.qty, :qty_picking=>line.qty
        assert_equal 1, line = skr_sales_orders(:picking).lines.unallocated.count
        assert_equal 0, skr_sales_orders(:complete).lines.unallocated.count
    end
end
