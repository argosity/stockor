require_relative '../../lib/StockorSaas'
require 'lanes/spec_helper'

module StockorSaas

    # Add more helper methods to be used by all tests here...

    class TestCase < Lanes::TestCase
        include StockorSaas
    end

    class ApiTestCase < Lanes::ApiTestCase
        include StockorSaas
    end

end
