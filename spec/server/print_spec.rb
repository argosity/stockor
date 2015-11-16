require_relative 'spec_helper'


class PrintSpec < Skr::TestCase

    it "can print" do
        inv = skr_sales_order(:tiny)
        print = Skr::Print.new('invoices', inv.id)
        # useful for debugging
        # File.open('/tmp/test.pdf', 'w'){|f| f.write print.output.read }
        assert print.output.length > 1000
    end

end
