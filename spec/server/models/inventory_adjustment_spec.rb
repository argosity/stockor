require_relative '../spec_helper'

class InventoryAdjustmentSpec < Skr::TestCase

    it "can be instantiated" do
        model = InventoryAdjustment.new
        model.must_be_instance_of(InventoryAdjustment)
    end

end
