require_relative '../spec_helper'

class VendorSpec < Skr::TestCase

    it "can be instantiated" do
        model = Vendor.new
        model.must_be_instance_of(Vendor)
    end

end
