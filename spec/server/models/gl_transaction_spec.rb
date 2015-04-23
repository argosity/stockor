require_relative '../spec_helper'

class GlTransactionSpec < Skr::TestCase

    it "can be instantiated" do
        model = GlTransaction.new
        model.must_be_instance_of(GlTransaction)
    end

end
