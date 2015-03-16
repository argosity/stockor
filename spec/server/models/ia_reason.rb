require_relative 'spec_helper'

describe Skr::IaReason do

    it "can be instantiated" do
        model = IaReason.new
        model.must_be_instance_of(IaReason)
    end

end
