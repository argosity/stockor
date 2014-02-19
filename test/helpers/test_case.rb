module Skr

    class TestCase < MiniTest::Unit::TestCase
        include ActiveRecord::TestFixtures
        include Skr

        self.fixture_path = File.dirname(__FILE__) + "/../fixtures"
        self.use_transactional_fixtures = false
        self.use_instantiated_fixtures = false
        fixtures :all
    end

end
