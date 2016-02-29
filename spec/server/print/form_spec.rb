require_relative '../spec_helper'

class PrintSpec < Skr::TestCase

    # for debugging add a generate(pdf) to one of the specs
    def generate(pdf)
        begin
            File.open('/tmp/skr-test.tex', 'w'){|f| f.write pdf.as_latex    }
            File.open('/tmp/skr-test.pdf', 'w'){|f| f.write pdf.as_pdf.read }
        rescue ErbLatex::LatexError=>e
            puts e.log.gsub(/^\*\n/,'')
            assert(false)
        end
    end

    it "can generate default invoice" do
        inv = skr_invoice(:tiny)
        inv.update_attributes amount_paid: inv.total - 2.22
        assert inv.update_attributes form: 'default'
        pdf = Skr::Print::Form.new('invoice', inv.hash_code)
        assert pdf.as_latex
    end

    it 'can generate labor invoice' do
        inv = skr_invoice(:tiny)
        assert inv.update_attributes form: 'labor'
        pdf = Skr::Print::Form.new('invoice', inv.hash_code)
        assert pdf.as_latex
    end

    it 'can generate sales order' do
        so = skr_sales_order(:tiny)
        pdf = Skr::Print::Form.new('sales-order', so.hash_code)
        assert pdf.as_latex
    end

end
