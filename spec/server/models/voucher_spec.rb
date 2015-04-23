require_relative '../spec_helper'

class VoucherSpec < Skr::TestCase

    it "can be instantiated" do
        model = Voucher.new
        model.must_be_instance_of(Voucher)
    end

end
