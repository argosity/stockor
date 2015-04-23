require_relative '../spec_helper'

class IaLineSpec < Skr::TestCase

    it "can be instantiated" do
        model = IaLine.new
        model.must_be_instance_of(IaLine)
    end

end
