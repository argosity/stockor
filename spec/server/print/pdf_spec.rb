require_relative '../spec_helper'


class PrintSpec < Skr::TestCase


    it "can print" do
        so = skr_sales_order(:tiny)

        pdf = Skr::Print::PDF.new('sales_order', so.hash_code)
        assert pdf # generating is commented because that specs fairly slow
        # assert pdf.output.length > 1000
        # useful for debugging
        # File.open('/tmp/test.pdf', 'w'){|f| f.write output.read }

    end

end
