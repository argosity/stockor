require_relative '../spec_helper'

class CustomerSpec < Skr::TestCase

    it "can be instantiated" do
        model = Customer.new
        model.must_be_instance_of(Customer)
    end

end
