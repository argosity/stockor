require_relative 'spec_helper'

describe Skr::IaLine do

    it "can be instantiated" do
        model = IaLine.new
        model.must_be_instance_of(IaLine)
    end

end
