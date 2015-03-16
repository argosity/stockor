require_relative 'spec_helper'

describe Skr::GlPeriod do

    it "can be instantiated" do
        model = GlPeriod.new
        model.must_be_instance_of(GlPeriod)
    end

end
