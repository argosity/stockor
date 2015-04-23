require_relative '../spec_helper'

class GlManualEntrySpec < Skr::TestCase

    it "can be instantiated" do
        model = GlManualEntry.new
        model.must_be_instance_of(GlManualEntry)
    end

end
