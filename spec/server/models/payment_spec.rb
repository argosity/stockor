require_relative '../spec_helper'

class PaymentSpec < Skr::TestCase

    it "can be created" do
        assert Payment.create(
            amount: 42.42,
            name: 'Test One, Two, Three',
            category: skr_payment_category(:labor),
            bank_account: skr_bank_account(:checking),
            notes: 'A test payment'
        ), "failed to create payment"
    end

    it "posts to general ledger" do
        bank_account = skr_bank_account(:checking)
        category = skr_payment_category(:labor)

        assert_difference ->{
            category.gl_account.trial_balance
        }, BigDecimal.new('42.42') do

            assert_difference ->{
                bank_account.gl_account.trial_balance
            }, BigDecimal.new('-42.42') do

                Payment.create(
                    amount: 42.42,
                    name: 'Test One, Two, Three',
                    category: category,
                    bank_account: bank_account,
                    notes: 'A test payment'
                )

            end
        end

    end

end
