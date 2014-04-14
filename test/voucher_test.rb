require_relative 'test_helper'


class VoucherTest < Skr::TestCase



    def test_creation
        por = skr_po_receipts(:first)
        assert por.vendor
        v = Voucher.new({ po_receipt: por })
        por.lines.each do | por_line |
            v.lines.build({ po_line: por_line.po_line })
        end
        assert_saves v
    end

    def test_state_transistions
        v=Voucher.new({ :po_receipt => skr_po_receipts(:first) })
        v.lines.build({
            :po_line => skr_po_lines(:second_on_first)
        })
        assert_saves v

        acct   = v.vendor.gl_payables_account
        before = acct.trial_balance
        v.state_name.must_equal :pending
        assert_difference 'acct.trial_balance', before - v.total do
            v.mark_confirmed
            assert_saves v
        end

    end

end
