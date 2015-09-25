require_relative 'spec_helper'


class PrintSpec < Skr::TestCase

    it "can print" do
        so = skr_sales_order(:tiny)
        print = Skr::Print.new('sales-orders', so.id)
        assert print.output.length > 1000
    end

end
