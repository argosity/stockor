require_relative '../spec_helper'

class SkuVendorSpec < Skr::TestCase

    it "can be instantiated" do
        model = SkuVendor.new
        model.must_be_instance_of(SkuVendor)
    end

end
