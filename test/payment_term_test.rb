require_relative 'test_helper'


class PaymentTermTest < Skr::TestCase


    def test_immediate_terms_are_identified
        assert skr_payment_terms(:cash).immediate?
        refute skr_payment_terms(:net30).immediate?
        assert skr_payment_terms(:cred_card).immediate?
        refute skr_payment_terms(:bonus30).immediate?
    end

    def test_percnum
        assert_kind_of  Skr::Core::Numbers::PercNum, skr_payment_terms(:bonus30).discount
        assert skr_payment_terms('10net30').discount.is_percentage?
        refute skr_payment_terms(:bonus30).discount.is_percentage?
    end

    def test_expirations
        assert_equal Date.today+30.days, skr_payment_terms('10net30').due_date_from(Date.today)
        assert_equal Date.today+10.days, skr_payment_terms('10net30').discount_expires_at
     end

end
