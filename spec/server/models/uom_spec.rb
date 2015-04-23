require_relative '../spec_helper'

class UomSpec < Skr::TestCase

    it "can be instantiated" do
        model = Uom.new
        model.must_be_instance_of(Uom)
    end

end
