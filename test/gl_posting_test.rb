require_relative 'test_helper'

class GlPostingTest < Skr::TestCase

    def setup
        gle = GlManualEntry.create({ notes: 'A good test' })
        @glt = gle.gl_transaction = GlTransaction.new({ source: gle })
        @glt.location = skr_locations(:default)
        @glt.add_posting( amount: 33.42, debit: skr_gl_accounts(:cash), credit: skr_gl_accounts(:inventory) )
    end

    def test_attribute_caching
        assert_saves @glt
        assert_equal '110001', @glt.credits.first.account_number
        assert_equal Date.today.year,  @glt.credits.first.year
        assert_equal Date.today.month, @glt.credits.first.period
    end


    def test_it_cannot_be_updated
        assert_saves @glt
        @glt.credits.first.amount = 33
        assert_raises( ActiveRecord::ReadOnlyRecord ) do
            @glt.credits.first.save
        end
    end

    def test_no_adding_to_transaction
        assert_saves @glt
        posting = @glt.credits.create({
                                 account_number: '100000',
                                 amount: 22
                             })
        assert posting.new_record?, "allowed saving an adhoc posting"
        assert_equal ["does not accept new postings"], posting.errors[:gl_transaction]
    end


end
