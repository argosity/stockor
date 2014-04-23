require_relative 'test_helper'

class InvoiceTest < Skr::TestCase

    def test_create_from_pt
        pt = skr_pick_tickets(:first)
        pt.lines.each{|l| l.qty_to_ship = l.qty }
        inv = Invoice.new
        inv.pick_ticket = pt
        inv.lines.from_pick_ticket!
        assert_saves inv
    end

    def test_applying_payments
        inv = skr_invoices(:unpaid)
        assert_equal 'open', inv.state
        inv.amount_paid = inv.total-10.2
        assert_difference ->{ GlAccount.default_for(:deposit_holding).trial_balance }, inv.total-10.2 do
            assert_saves inv
            assert_equal 'partial', inv.state
        end
        inv.amount_paid += 1.12
        assert_difference ->{ GlAccount.default_for(:deposit_holding).trial_balance }, 1.12 do
            assert_saves inv
            assert_equal 'partial', inv.state
        end

        assert_difference ->{ GlAccount.default_for(:deposit_holding).trial_balance }, inv.unpaid_amount do
            inv.amount_paid = inv.total
            assert_saves inv
            assert_equal 'paid', inv.state
        end
    end

    def test_applying_payments_while_saving
        inv = Invoice.new({ customer: skr_customers(:stitt), location: skr_locations(:default) })
        inv.lines.build({ sku_loc: skr_sku_locs(:hatdefault),   qty: 1, price: 8 })
        inv.lines.build({ sku_loc: skr_sku_locs(:glovedefault), qty: 1, price: 2 })
        inv.amount_paid = inv.total
        assert_difference ->{ GlAccount.default_for(:deposit_holding).trial_balance }, 10.0 do
            assert_saves inv
            assert_equal 'paid', inv.state
        end
    end

    def test_detail_view
        inv = Invoice.with_details.where( id: skr_invoices(:unpaid).id ).first
        assert_equal inv.sales_order.visible_id, inv.sales_order_visible_id
        assert_equal 13.88, inv.total
    end

    def test_create_from_sales_order
        inv = Invoice.new( sales_order: skr_sales_orders(:picking) )
        inv.lines.from_sales_order!
        assert_saves inv
        assert_equal 2, inv.lines.size
        assert_equal 3.11, inv.lines.first.price
        assert_equal 5, inv.lines.first.qty
        assert_equal 18.94, inv.total

    end

end
