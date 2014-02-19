require_relative 'test_helper'

class GlPeriodTest < Skr::TestCase

    def test_it_returns_current_period
        glp = GlPeriod.current
        glp.new_record?.must_equal false
        glp.period.must_equal Time.now.month
        glp.year.must_equal Time.now.year
    end

end
