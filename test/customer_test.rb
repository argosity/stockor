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

end
