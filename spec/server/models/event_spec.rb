require_relative '../spec_helper'

class EventSpec < Skr::TestCase

    it "can be instantiated" do
        model = Event.new(title: 'Bob Bob & Bob', sku: skr_sku(:yarn))
        assert_saves model
    end

    it 'can query sales' do
        event = skr_event(:top)
        event.invoice_xrefs.build(
            invoice: skr_invoice(:event)
        )
        assert_saves event
        assert_equal 1, event.reload.invoices.length
        assert_equal 2, event.invoice_lines.ea_qty
        invoice = event.invoices.first
        assert_equal event, invoice.event
    end

    it 'can build invoice' do
        event = skr_event(:top)
        invoice = event.invoices.new
        invoice.customer = skr_customer(:billy)
        invoice.lines.build(sku_loc: skr_sku_loc(:glove_def), qty: 1, price: 10)
        assert_saves invoice
        assert_equal event, invoice.reload.event
    end

end
