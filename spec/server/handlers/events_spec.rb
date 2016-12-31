# coding: utf-8
require_relative '../spec_helper'

class EventsSpec < Skr::ApiTestCase

    it 'lists sku and qty remaining data' do
        event = skr_event(:top)
        get '/api/skr/public/events.json', { code: event.code }
        assert_ok
        assert_equal event.sku.code,  json_data.sku.code
        assert_equal event.sku.price, BigDecimal.new(json_data.sku.price)
        assert_equal 341, json_data.qty_remaining
    end

end
