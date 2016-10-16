require 'lanes'
Lanes.silence_logs do
    require 'skr'
    require 'lanes/spec_helper'
    require 'webmock/minitest'
    require 'vcr'
end

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

    def table_rows
        results = super
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

ActiveRecord::FixtureSet.prepend StockorFixtureTestPatches


VCR_OPTS = {
    record: :none
}

VCR.configure do |config|

    config.cassette_library_dir = "spec/vcr"
    config.hook_into :webmock
    config.allow_http_connections_when_no_cassette = false
end

ActiveRecord::FixtureSet.send :include, StockorFixtureTestPatches
