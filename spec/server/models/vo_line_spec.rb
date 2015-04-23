require_relative '../spec_helper'

class VoLineSpec < Skr::TestCase

    it "can be instantiated" do
        model = VoLine.new
        model.must_be_instance_of(VoLine)
    end

end
