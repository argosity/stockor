require_relative 'test_helper'

class UomTest < Skr::TestCase


    def test_combining
        uom = Uom.new
        uom.size = 1
        uom.code = 'BOX'
        assert_equal 'BOX', uom.combined_uom
        uom.size = 10
        assert_equal 'BOX/10', uom.combined_uom
    end
end
