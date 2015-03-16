require_relative 'spec_helper'

describe Skr::GlPosting do

    it "can be instantiated" do
        model = GlPosting.new
        model.must_be_instance_of(GlPosting)
    end

end
