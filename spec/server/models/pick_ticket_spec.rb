require_relative '../spec_helper'

class PickTicketSpec < Skr::TestCase

    it "can be instantiated" do
        model = PickTicket.new
        model.must_be_instance_of(PickTicket)
    end

end
