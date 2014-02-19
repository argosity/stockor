require_relative 'test_helper'

class GlPostingTest < Skr::TestCase

    def setup
        gle = GlManualEntry.create({ notes: 'A good test' })
        @glt = GlTransaction.new({ source: gle, :amount=> 33.42 })
        @glt.location = skr_locations(:default)
        @glt.credit.account = skr_gl_accounts(:inventory)
        @glt.debit.account  = skr_gl_accounts(:cash)
    end

    def test_attribute_caching
        assert_saves @glt
        assert_equal '140001', @glt.credit.account_number
        assert_equal Date.today.year,  @glt.credit.year
        assert_equal Date.today.month, @glt.credit.period
    end


    def test_it_cannot_be_updated
        assert_saves @glt
        @glt.credit.amount = 33
        assert_raises( ActiveRecord::ReadOnlyRecord ) do
            @glt.credit.save
        end
    end

    def test_no_adding_to_transaction
        assert_saves @glt
        posting = @glt.postings.create({
                                 account: skr_gl_accounts(:cash),
                                 amount: 22
                             })
        assert posting.new_record?
        assert posting.errors.include?(:transaction)
    end


end
