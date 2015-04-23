require_relative '../spec_helper'

class GlPostingSpec < Skr::TestCase

    it "can be instantiated" do
        model = GlPosting.new
        model.must_be_instance_of(GlPosting)
    end

end
