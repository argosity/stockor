require_relative 'spec_helper'

describe Skr::GlManualEntry do

    it "can be instantiated" do
        model = GlManualEntry.new
        model.must_be_instance_of(GlManualEntry)
    end

end
