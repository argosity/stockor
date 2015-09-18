require_relative '../spec_helper'

class SoLineSpec < Skr::TestCase

    it "can load uom_choices" do
        line = skr_so_line(:tiny_glove)
        assert_equal ['PR', 'CS' ], line.uom_choices.pluck(:code)
    end

end
