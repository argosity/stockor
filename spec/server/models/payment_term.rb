require_relative 'spec_helper'

describe Skr::PaymentTerm do

    it "can be instantiated" do
        model = PaymentTerm.new
        model.must_be_instance_of(PaymentTerm)
    end

end
