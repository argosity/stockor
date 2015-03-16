require_relative 'spec_helper'

describe Skr::Sku do

    it "can be instantiated" do
        model = Sku.new
        model.must_be_instance_of(Sku)
    end

end
