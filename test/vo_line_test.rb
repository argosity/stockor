require_relative 'test_helper'


class VoucherLineTest < Skr::TestCase


    def test_gl_posting
        acct = GlAccount.default_for( :inventory_receipts_clearing )
        po = skr_purchase_orders(:first)

        v = Voucher.new({ :purchase_order => po })
        old_balance = acct.trial_balance
        po.lines.each do | poline |
            v.lines.build({ :po_line => poline })
        end
        assert_saves v
        assert_equal old_balance - v.total, acct.trial_balance
    end

end
