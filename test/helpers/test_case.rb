module Skr

    class TestCase < ActiveSupport::TestCase
        include ActiveRecord::TestFixtures
        include Skr

        self.fixture_path = File.dirname(__FILE__) + "/../fixtures"
        self.use_transactional_fixtures = true

        fixtures :all
    end

end
