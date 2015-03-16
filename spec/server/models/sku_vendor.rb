require_relative 'spec_helper'

describe Skr::SkuVendor do

    it "can be instantiated" do
        model = SkuVendor.new
        model.must_be_instance_of(SkuVendor)
    end

end
