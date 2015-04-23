require_relative '../spec_helper'

class AddressSpec < Skr::TestCase

    it "can be instantiated" do
        model = Address.new
        model.must_be_instance_of(Address)
    end

end
