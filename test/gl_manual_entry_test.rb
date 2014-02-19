require_relative 'test_helper'

class GlManualEntryTest < Skr::TestCase

    def test_notes_are_copied
        gle = GlManualEntry.new({ notes: 'A good test' })
        tran = gle.build_transaction( amount: 33.42 )
        tran.credit.account = skr_gl_accounts(:inventory)
        tran.debit.account  = skr_gl_accounts(:cash)

        assert_saves gle
        assert_equal gle.notes, tran.description
    end

    def test_querying_using_visible_id
        GlManualEntry.with_visible_id( 23)
    end
end
