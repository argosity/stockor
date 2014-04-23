require_relative 'test_helper'

class CustomerTest < Skr::TestCase

    def setup
        @customer=Customer.new({
            code: 'TEST',
            name: 'Mr Test Co',
            billing_address: skr_addresses(:bigco),
            shipping_address: skr_addresses(:bigco),
            terms: skr_payment_terms(:net30)
        })
    end

    def test_saving
        assert_saves @customer
    end

    def test_it_sets_gl
        assert_saves @customer
        assert_equal '1200', @customer.gl_receivables_account.number
    end


    def test_balance_recording
        inv = Invoice.new( sales_order: skr_sales_orders(:picking) )
        inv.lines.from_sales_order!
        customer = inv.sales_order.customer
        assert_difference ->{ customer.reload.open_balance }, 18.94 do
            assert_saves inv
        end
    end

end
