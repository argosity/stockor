require_relative 'test_helper'

class GlManualEntryTest < Skr::TestCase

    def test_notes_are_copied
        gle = GlManualEntry.new({ notes: 'A good test' })
        tran = gle.build_transaction({ location: Location.default })
        tran.push_debit_credit( 33.42, skr_gl_accounts(:cash), skr_gl_accounts(:inventory) )

        assert_saves gle
        assert_equal gle.notes, tran.description
    end

    def test_querying_using_visible_id
        GlManualEntry.with_visible_id( 23)
    end
end
