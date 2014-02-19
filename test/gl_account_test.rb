require_relative 'test_helper'


class GlAccountTest < Skr::TestCase

    def test_balance
        gla = skr_gl_accounts(:marketing)

        assert_equal 3033.28, gla.balance_for( skr_gl_periods(:nov2013) )

        assert_equal 3133.28, gla.balance_for( skr_gl_periods(:dec2013) )

        assert_equal 0, gla.balance_for( skr_gl_periods(:close2013) )

        assert_equal 356.81, gla.balance_for( skr_gl_periods(:jan2014) )

        assert_equal -843.61, gla.trial_balance # Our free hats brings the expense account to a negative balance

    end



end
