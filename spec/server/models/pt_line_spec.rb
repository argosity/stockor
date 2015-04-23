require_relative '../spec_helper'

class PtLineSpec < Skr::TestCase

    it "can be instantiated" do
        model = PtLine.new
        model.must_be_instance_of(PtLine)
    end

end
