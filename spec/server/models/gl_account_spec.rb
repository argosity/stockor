require_relative '../spec_helper'

class GlAccountSpec < Skr::TestCase

    it "can be instantiated" do
        model = GlAccount.new
        model.must_be_instance_of(GlAccount)
    end

end
