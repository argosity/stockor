require_relative 'spec_helper'

describe Skr::SkuLoc do

    it "can be instantiated" do
        model = SkuLoc.new
        model.must_be_instance_of(SkuLoc)
    end

end
