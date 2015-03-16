require_relative 'spec_helper'

describe Skr::PoLine do

    it "can be instantiated" do
        model = PoLine.new
        model.must_be_instance_of(PoLine)
    end

end
