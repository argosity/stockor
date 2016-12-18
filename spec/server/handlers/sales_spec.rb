# coding: utf-8
require_relative '../spec_helper'

class SalesSpec < Skr::ApiTestCase

    subject { Skr::Handlers::Sales }
    let (:authentication) { Lanes::API::AuthenticationProvider.new({}) }

    let (:data)    {
        {
            form: 'ticket',
            skus: [{sku_id: skr_sku(:hat).id, qty: 3}],
            billing_address: {
                name: "Zoro", email: "zoro@anon.mx", phone: "123-456-7890", postal_code: "max233"
            },
            credit_card: {
                name: "Zoro Resplendant", number: "4111111111111111",
                month: 11, year: 18, verification_value: 222
            },
            email: {
                from: 'order@bob.com',
                signature: "very much respect,\n\nBob!"
            },
            pdf: {
                form: 'ticket',
                name: 'Greeting Card',
                message: "Thank You Very Much!",
                event_info: "Will be held rain or shine, bring your bumbershoots"
            }
        }
    }

    it 'saves and charges when given valid inputs' do
        with_stubbed_payment_proccessor(authorization: 'yep-it-works') do
            assert_difference ->{ Invoice.count }, 1 do
                assert_difference ->{ InvLine.count }, 1 do
                    post '/api/skr/public/sales.json', data
                end
            end
            assert_ok
            invoice = Invoice.find_by_hash_code(json_data.hash_code)
            assert invoice
            assert_equal 'yep-it-works', invoice.payments.first.metadata['authorization']
        end
    end

    it 'sends email' do
        with_stubbed_payment_proccessor(authorization: 'yep-it-works') do
            post '/api/skr/public/sales.json', data
            assert_ok
            invoice = Invoice.find_by_hash_code(json_data.hash_code)
            email = Mail::TestMailer.deliveries.last
            assert_equal email.to, [data[:billing_address][:email]]
            assert_equal email.from, [data[:email][:from]]
            assert_includes email.subject, 'recent purchase'
            assert_includes email.body, "ID is #{invoice.visible_id}"
            assert_includes email.body, data[:email][:signature]
        end
    end

    it 'saves arbitrary json on pdf' do
        custom = data
        custom[:pdf][:xtrablah] = { one: 1 }
        with_stubbed_payment_proccessor(authorization: 'yep-it-works') do
            post '/api/skr/public/sales.json', custom
        end
        invoice = Invoice.find_by_hash_code(json_data.hash_code)
        assert_equal invoice.options['pdf']['xtrablah'] , { 'one' => 1 }
    end

end
