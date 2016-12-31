# coding: utf-8
require_relative '../spec_helper'

class SalesSpec < Skr::ApiTestCase

    subject { Skr::Handlers::Sales }
    let (:authentication) { Lanes::API::AuthenticationProvider.new({}) }

    it 'can query only public skus' do
        sku = skr_sku(:yarn)
        sku.update_attributes(is_public: false)
        get '/api/skr/public/skus.json', q: { code: sku.code }
        assert_ok
        assert_empty json_data
    end

    it 'can query by events, even if sku isnt public' do
        event = skr_event(:top)
        event.sku.update_attributes(is_public: false)
        get '/api/skr/public/skus.json', for_event: event.code
        assert_ok
        assert_equal 1, json_data.length
        assert_equal json_data.first.code, event.sku.code
    end
end
