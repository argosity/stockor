require_relative 'spec_helper'

describe Skr::Vendor do

    it "can be instantiated" do
        model = Vendor.new
        model.must_be_instance_of(Vendor)
    end

end
