require_relative '../spec_helper'

class SkuLocSpec < Skr::TestCase

    it "can be instantiated" do
        model = SkuLoc.new
        model.must_be_instance_of(SkuLoc)
    end

end
