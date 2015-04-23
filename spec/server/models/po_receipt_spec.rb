require_relative '../spec_helper'

class PoReceiptSpec < Skr::TestCase

    it "can be instantiated" do
        model = PoReceipt.new
        model.must_be_instance_of(PoReceipt)
    end

end
