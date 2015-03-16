require_relative 'spec_helper'

describe Skr::VoLine do

    it "can be instantiated" do
        model = VoLine.new
        model.must_be_instance_of(VoLine)
    end

end
