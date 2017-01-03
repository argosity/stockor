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

    it 'saves when set on invoice' do
        invoice = Invoice.new(customer: skr_customer(:billy))
        invoice.event = event = skr_event(:top)
        invoice.lines.build(sku_loc: skr_sku_loc(:glove_def), qty: 1, price: 10)
        assert_saves invoice
        assert_equal event, invoice.reload.event
        assert_equal event.invoices.first, invoice
        assert_equal 'ticket', invoice.form
    end

end
