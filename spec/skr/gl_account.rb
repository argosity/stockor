require_relative 'spec_helper'

describe Skr::GlAccount do

    it "can be instantiated" do
        model = GlAccount.new
        model.must_be_instance_of(GlAccount)
    end

end
