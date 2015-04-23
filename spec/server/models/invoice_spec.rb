require_relative '../spec_helper'

class InvoiceSpec < Skr::TestCase

    it "can be instantiated" do
        model = Invoice.new
        model.must_be_instance_of(Invoice)
    end

end
