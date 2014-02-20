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
        assert @customer.save
    end

    def test_it_sets_gl
        assert @customer.save
        assert_equal '1200', @customer.gl_receivables_account.number
    end

end
