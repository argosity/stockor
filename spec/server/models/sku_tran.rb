require_relative 'spec_helper'

describe Skr::SkuTran do

    it "can be instantiated" do
        model = SkuTran.new
        model.must_be_instance_of(SkuTran)
    end

end
