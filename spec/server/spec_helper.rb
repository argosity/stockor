require_relative '../../lib/stockor'
require 'lanes/spec_helper'

class Lanes::TestCase
    include Skr
end

module Skr

    # Add more helper methods to be used by all tests here...

    class TestCase < Lanes::TestCase
        include Skr
    end

    class ApiTestCase < Lanes::ApiTestCase
        include Skr
    end

end

module StockorFixtureTestPatches
    extend ActiveSupport::Concern

    included do
        alias_method_chain :table_rows, :custom_autoset_stockor_fields
    end

    def table_rows_with_custom_autoset_stockor_fields
        results = table_rows_without_custom_autoset_stockor_fields
        if model_class && model_class < ActiveRecord::Base
            results[ table_name ].each do | row |
                if self['hash_code'].blank? && model_class.column_names.include?('hash_code')
                    row['hash_code'] = Lanes::Strings.random(8)
                end
            end
        end
        results
    end
end

ActiveRecord::FixtureSet.send :include, StockorFixtureTestPatches
