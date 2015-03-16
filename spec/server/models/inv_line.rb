require_relative 'spec_helper'

describe Skr::InvLine do

    it "can be instantiated" do
        model = InvLine.new
        model.must_be_instance_of(InvLine)
    end

end
