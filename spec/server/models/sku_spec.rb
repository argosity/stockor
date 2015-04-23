require_relative '../spec_helper'

class SkuSpec < Skr::TestCase

    it "can be instantiated" do
        model = Sku.new
        model.must_be_instance_of(Sku)
    end

end
