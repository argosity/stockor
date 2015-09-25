require_relative '../spec_helper'

class AddressSpec < Skr::TestCase


    it "can be converted to plain string" do
        address = skr_address(:hg_billing).to_s(include: [:email,:phone])
        assert_equal(address, "Hansel and Gretel\n499 Julianne Radial\nSouth Timmyville WI, 38200\nschuyler@krajcik.name 379-772-4947 x945")
    end

end
