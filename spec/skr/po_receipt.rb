require_relative 'spec_helper'

describe Skr::PoReceipt do

    it "can be instantiated" do
        model = PoReceipt.new
        model.must_be_instance_of(PoReceipt)
    end

end
