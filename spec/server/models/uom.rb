require_relative 'spec_helper'

describe Skr::Uom do

    it "can be instantiated" do
        model = Uom.new
        model.must_be_instance_of(Uom)
    end

end
