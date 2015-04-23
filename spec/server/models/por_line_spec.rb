require_relative '../spec_helper'

class PorLineSpec < Skr::TestCase

    it "can be instantiated" do
        model = PorLine.new
        model.must_be_instance_of(PorLine)
    end

end
