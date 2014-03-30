require_relative 'test_helper'

class IaReasonTest < Skr::TestCase

    def test_gl_posting
        il = skr_inventory_adjustments(:first)
        il.state.must_equal 'pending'
        il.mark_applied
    end

end
