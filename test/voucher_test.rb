require_relative 'test_helper'


class VoucherTest < Skr::TestCase


    def test_posting_freight
        po    = skr_purchase_orders(:first)
        vouch = Voucher.new( freight: 42.99, purchase_order: po )
        assert_difference ->{ po.vendor.gl_freight_account.trial_balance }, 42.99 do
            vouch.save!
        end
    end

    def test_state_transistions
        v=Voucher.create!({ :freight=>42.99, :purchase_order => skr_purchase_orders(:first), refno: '3432' })
        v.lines.build({
            :po_line => skr_po_lines(:second_on_first)
        })

        acct   = v.vendor.gl_payables_account
        before = acct.trial_balance
        v.state_name.must_equal :pending
        assert_difference 'acct.trial_balance', before - v.total do
            v.mark_confirmed
            assert_saves v
        end

        # acct = bank_accounts(:checking).gl_account
        # before = acct.masked_balance
        # v.payment_line = payment_lines(:product)

        # assert_difference 'acct.trial_balance', v.total*-1 do
        #     v.mark_paid!
        # end
    end

end
