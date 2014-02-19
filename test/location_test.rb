require_relative 'test_helper'

class LocationTest < Skr::TestCase

    def test_it_copies_branch
        loc = Location.new
        assert_equal '01', loc.gl_branch_code
    end

end
