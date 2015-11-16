require_relative 'spec_helper'

class CustomerProjectSpec < Skr::TestCase

    it "can be instantiated" do
        model = CustomerProject.new
        model.must_be_instance_of(CustomerProject)
    end

end
