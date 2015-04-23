require_relative '../spec_helper'

class GlPeriodSpec < Skr::TestCase

    it "can be instantiated" do
        model = GlPeriod.new
        model.must_be_instance_of(GlPeriod)
    end

end
