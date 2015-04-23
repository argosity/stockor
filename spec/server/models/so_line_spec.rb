require_relative '../spec_helper'

class SoLineSpec < Skr::TestCase

    it "can be instantiated" do
        model = SoLine.new
        model.must_be_instance_of(SoLine)
    end

end
