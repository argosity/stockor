require_relative '../spec_helper'

class PrintSpec < Skr::TestCase

    it "can print" do
        inv = skr_invoice(:tiny)
        pdf = Skr::Print::PDF.new('invoice', inv.hash_code)
        assert(pdf.output.length > 1000)
        # so = skr_sales_order(:tiny)
        # generation is turned off for speed of specs
        # pdf = Skr::Print::PDF.new('sales_order', so.hash_code)
        # File.open('/tmp/skr-test.pdf', 'w'){|f| f.write pdf.output.read }
    end

end
