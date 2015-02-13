require_relative 'spec_helper'

describe Skr::Location do

    it "can be instantiated" do
        model = Location.new
        model.must_be_instance_of(Location)
    end

end
