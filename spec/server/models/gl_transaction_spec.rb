require_relative '../spec_helper'

class GlTransactionSpec < Skr::TestCase

    it "can be queried with details" do
        models = GlTransaction.with_details
        assert models
    end

end
