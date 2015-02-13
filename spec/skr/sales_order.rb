require_relative 'spec_helper'

describe Skr::SalesOrder do

    it "can be instantiated" do
        model = SalesOrder.new
        model.must_be_instance_of(SalesOrder)
    end

end
