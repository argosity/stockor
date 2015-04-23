require_relative '../spec_helper'

class SkuTranSpec < Skr::TestCase

    it "can be instantiated" do
        model = SkuTran.new
        model.must_be_instance_of(SkuTran)
    end

end
