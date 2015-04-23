require_relative '../spec_helper'

class PurchaseOrderSpec < Skr::TestCase

    it "can be instantiated" do
        model = PurchaseOrder.new
        model.must_be_instance_of(PurchaseOrder)
    end

end
