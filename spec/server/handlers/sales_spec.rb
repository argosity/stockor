# coding: utf-8
require_relative '../spec_helper'

class SalesSpec < Skr::ApiTestCase

    subject { Skr::Handlers::Sales }
    let (:authentication) { Lanes::API::AuthenticationProvider.new({}) }

    let (:data)    {
        { 'form' => "ticket",
          'skus' => [{'sku_id' => skr_sku(:hat).id, 'qty' => 3}],
          'billing_address' => {
              'name' => "Zoro", 'email' => "zoro@anon.mx",
              'phone' => "123-456-7890", 'postal_code' => "max233"
          },
          'credit_card' => {
              'name' => "Zoro Resplendant", 'number' => "4111111111111111",
              'month' => 11, 'year' => 18, 'verification_value' => 222
          }
        }
    }

    it 'saves and charges when given valid inputs' do
        with_stubbed_payment_proccessor(authorization: 'yep-it-works') do
            assert_difference ->{ Invoice.count }, 1 do
                post '/api/skr/public/sales.json', data
            end
            assert_ok
            invoice = Invoice.find_by_hash_code(json_data.hash_code)
            assert invoice
            assert_equal 'yep-it-works', invoice.payments.first.metadata['authorization']
        end

    end
end
