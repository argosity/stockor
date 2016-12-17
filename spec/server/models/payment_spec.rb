require_relative '../spec_helper'

class PaymentSpec < Skr::TestCase

    let (:amount)       { BigDecimal.new('42.42')      }
    let (:vendor)       { skr_vendor(:cinderella)      }
    let (:category)     { skr_payment_category(:labor) }
    let (:bank_account) { skr_bank_account(:checking)  }
    let (:invoice)      { skr_invoice(:tiny)           }
    let (:cc_authorization) { '123456789' }

    def around
        settings = Lanes::SystemSettings.for_ext('skr-ccgateway')
        prev_gw_settings = settings['credit_card_gateway']
        settings['credit_card_gateway'] = {
            "type" =>"authorize_net_gateway", "login"=>"testlogin", "password"=>"testpw"
        }
        settings.persist!
        # :all, :none, :new_episodes, :once
        VCR.use_cassette(:payments, :record => :none) do
            yield
        end
    ensure
        settings['credit_card_gateway'] = prev_gw_settings
        settings.persist!
    end

    it "can be created" do
        assert Payment.create(
            amount: amount, name: 'Test One, Two, Three',
            category: category, bank_account: bank_account,
            notes: 'A test payment'
        ), "failed to create payment"
    end

    it "posts to gl for categories" do
        assert_difference -> { category.gl_account.trial_balance }, amount do
            assert_difference -> { bank_account.gl_account.trial_balance }, amount * -1 do
                assert Payment.create(
                           amount: amount, category: category,
                           bank_account: bank_account,
                           name: 'Test One, Two, Three'
                )
            end
        end
    end

    it "posts to gl for vendors" do
        assert_difference -> { vendor.gl_payables_account.trial_balance }, amount do
            assert_difference -> { bank_account.gl_account.trial_balance }, amount * -1 do
                assert Payment.create( amount: amount, vendor: vendor, bank_account: bank_account )
            end
        end
    end

    it 'posts to gl for invoices' do
        assert_difference -> {
            invoice.customer.gl_receivables_account.trial_balance
        }, amount * -1 do
            assert_difference ->{ bank_account.gl_account.trial_balance }, amount do
                pymnt = Payment.create(
                    amount: amount, invoice: invoice, bank_account: bank_account
                )
                assert_equal pymnt.name, invoice.billing_address.name
            end
        end
    end

    it 'charges when saving if card and invoice are present' do
        bank_account = skr_bank_account(:checking)
        payment = Payment.new(
            amount: amount, invoice: invoice, bank_account: bank_account
        )
        payment.credit_card = {
            'name'   => 'Bob Tester',
            'number' => '4111111111111111',
            'month'  =>  '8',
            'year'   => Time.now.year + 1,
            'verification_value' => '000'
        }
        refute payment.save # VCR cassete returns failure by default

        with_stubbed_payment_proccessor(authorization: '123456789') do
            assert payment.save
        end
        assert_equal('123456789', payment.metadata["authorization"])
    end

end
