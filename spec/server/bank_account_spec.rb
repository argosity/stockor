require_relative 'spec_helper'

class BankAccountSpec < Skr::TestCase

    it "can be instantiated" do
        model = BankAccount.new
        model.must_be_instance_of(BankAccount)
    end

end
