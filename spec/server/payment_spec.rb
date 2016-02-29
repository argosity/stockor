require_relative 'spec_helper'

class PaymentSpec < Skr::TestCase

    it "can be instantiated" do
        model = Payment.new
        model.must_be_instance_of(Payment)
    end

end
