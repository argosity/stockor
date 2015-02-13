require_relative 'spec_helper'

describe Skr::Invoice do

    it "can be instantiated" do
        model = Invoice.new
        model.must_be_instance_of(Invoice)
    end

end
