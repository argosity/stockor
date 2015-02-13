require_relative 'spec_helper'

describe Skr::PorLine do

    it "can be instantiated" do
        model = PorLine.new
        model.must_be_instance_of(PorLine)
    end

end
