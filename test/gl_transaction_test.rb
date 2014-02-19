require_relative 'test_helper'

class GlTransactionTest < Skr::TestCase


    def setup
        gle = GlManualEntry.create({ notes: 'A good test' })
        @glt = GlTransaction.new({ source: gle, :amount=> 33.42 })
        @glt.location = skr_locations(:default)
        @glt.credit.account = skr_gl_accounts(:inventory)
        @glt.debit.account  = skr_gl_accounts(:cash)
        assert_saves @glt
    end

    def test_no_updates
        assert_raises( ActiveRecord::ReadOnlyRecord ) do
            @glt.credit.amount = 33333
            @glt.credit.save
        end
    end

    def test_debit_is_negative
        assert_equal(  33.42, @glt.credit.amount )
        assert_equal( -33.42, @glt.debit.amount )
    end

    def test_no_duplicate_accounts
        @glt.credit.account = @glt.debit.account
        @glt.save
        assert @glt.errors.include?(:postings)
    end

    def test_no_differing_amounts
        @glt.credit.amount = 18
        @glt.save
        assert @glt.errors.include?(:postings)
    end



end
