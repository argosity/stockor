require_relative '../spec_helper'

class PoLineSpec < Skr::TestCase

    it "can be instantiated" do
        model = PoLine.new
        model.must_be_instance_of(PoLine)
    end

end
