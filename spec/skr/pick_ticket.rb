require_relative 'spec_helper'

describe Skr::PickTicket do

    it "can be instantiated" do
        model = PickTicket.new
        model.must_be_instance_of(PickTicket)
    end

end
