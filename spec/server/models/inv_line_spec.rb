require_relative '../spec_helper'

class InvLineSpec < Skr::TestCase

    it "can be instantiated" do
        model = InvLine.new
        model.must_be_instance_of(InvLine)
    end

end
