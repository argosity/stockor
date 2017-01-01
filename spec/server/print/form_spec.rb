require_relative '../spec_helper'

class PrintSpec < Skr::TestCase

    # for debugging add a generate(pdf) to one of the specs
    def generate(pdf)
        config =  Lanes::SystemSettings.config
        unless config.logo and config.logo.file
            logo = config.build_print_logo
            logo.file = Pathname.new(__FILE__).dirname.join('../../fixtures/stockor.png').open
            logo.save!
            config.save!
        end

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
        inv.payments.create!(
            amount: inv.total - 2.22,
            name: 'test', bank_account: skr_bank_account(:checking)
        )
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

    it 'can generate checks' do
        pymnt = skr_payment(:bigco)
        pdf = Skr::Print::Form.new('payment', pymnt.hash_code)
        assert pdf.as_latex
    end

    it 'can generate tickets' do
        inv = skr_invoice(:event)
        assert inv.update_attributes form: 'ticket'
        event = skr_event(:top)
        event.invoice_xrefs.build(invoice: inv)
        photo = event.build_photo
        photo.file = Pathname.new(__FILE__).dirname
                         .join('../../fixtures/generic-band.jpg').open
        photo.save!
        assert_saves event
        pdf = Skr::Print::Form.new('invoice', inv.hash_code)
        assert pdf.as_latex
    end


end
