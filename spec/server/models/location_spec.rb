require_relative '../spec_helper'

class LocationSpec < Skr::TestCase

    it "can be instantiated" do
        model = Location.new
        model.must_be_instance_of(Location)
    end

end
