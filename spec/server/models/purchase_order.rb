require_relative 'spec_helper'

describe Skr::PurchaseOrder do

    it "can be instantiated" do
        model = PurchaseOrder.new
        model.must_be_instance_of(PurchaseOrder)
    end

end
