require_relative 'test_helper'

class GlTransactionTest < Skr::TestCase


    def setup
        @gle = GlManualEntry.create({ notes: 'A good test' })
        @glt = @gle.build_gl_transaction({ description: 'test manual source', source: @gle, location: Location.default })
    end

    def test_stand_alone_creation
        @glt.add_posting( amount: 22.1, debit: skr_gl_accounts(:cash), credit: skr_gl_accounts(:inventory) )
        assert_saves @glt
    end

    def test_no_updates
        glt = skr_gl_transactions(:free_hats)
        assert_raises( ActiveRecord::ReadOnlyRecord ) do
            glt.description = 'updated'
            assert_saves glt
        end
    end

    def test_no_differing_amounts
        @glt.add_posting( amount: 22.42, debit: skr_gl_accounts(:cash), credit: skr_gl_accounts(:inventory) )
        @glt.credits.first.amount = 18
        refute @glt.save, "allowed saving with mismatched amounts"
        assert_equal ['must equal debits'], @glt.errors[:credits]
    end

    def test_nested_recording
        tran = GlTransaction.record do | glt |
            assert_equal glt, GlTransaction.current
            GlTransaction.record( description: '2nd level' ) do | glt2 |
                refute_equal glt, glt2
                assert_equal glt2, GlTransaction.current
            end
        end
        assert tran.new_record?
        assert tran.errors.empty?, "since no postings, it shouldn't attempt to save"
        refute_saves tran
        refute tran.errors.empty?
    end

    def test_compacting
        tran = GlTransaction.record do | glt |
            glt.add_posting( amount: 12.12, debit: skr_gl_accounts(:cash), credit: skr_gl_accounts(:inventory) )
            glt.add_posting( amount: 42.42, debit: skr_gl_accounts(:cash), credit: skr_gl_accounts(:inventory) )
            { attributes: { source: @gle, description: 'A Test', location: Location.default } }
        end
        assert_saves tran
        assert_equal 1, tran.debits.size
        assert_equal 1, tran.credits.count
        assert_equal '54.54', tran.credits.total.to_s
        assert_equal '-54.54', tran.debits.total.to_s
    end

end
