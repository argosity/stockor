require_relative 'test_helper'

class GlManualEntryTest < Skr::TestCase

    def test_notes_are_copied
        gle = GlManualEntry.new({ notes: 'A good test' })
        tran = gle.gl_transaction = GlTransaction.new( location: Location.default )
        tran.add_posting( amount: 33.42, debit: skr_gl_accounts(:cash), credit: skr_gl_accounts(:inventory) )

        assert_saves gle
        assert_equal gle.notes, tran.description
    end

    def test_querying_using_visible_id
        GlManualEntry.with_visible_id( 23)
    end
end
