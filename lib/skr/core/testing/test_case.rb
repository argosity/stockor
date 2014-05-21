module Skr

    class TestCase < ActiveSupport::TestCase
        include ActiveRecord::TestFixtures
        include Skr

        self.fixture_path = Skr::Core::Testing.fixtures_path
        self.use_transactional_fixtures = true

        fixtures :all
    end

end
