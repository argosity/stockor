require_relative 'spec_helper'

class TimeEntrySpec < Skr::TestCase

    it "can be instantiated" do
        model = TimeEntry.new
        model.must_be_instance_of(TimeEntry)
    end

end
