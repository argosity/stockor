require_relative '../spec_helper'

class IaReasonSpec < Skr::TestCase

    it "can be instantiated" do
        model = IaReason.new
        model.must_be_instance_of(IaReason)
    end

end
