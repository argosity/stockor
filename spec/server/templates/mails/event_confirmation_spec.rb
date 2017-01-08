require_relative '../../spec_helper'

class EventConfirmationSpec < Skr::TestCase

    subject { Skr::Templates::Mails::EventConfirmation }

    let(:invoice) {
        inv = skr_invoice(:event)
        inv.event = skr_event(:top)
        inv.save!
        inv
    }

    it 'reads template' do
        tmpl = subject.new(invoice: invoice)
        assert tmpl.pathname.exist?
    end

    it 'generates' do
        tmpl = subject.new(invoice: invoice)
        assert_includes(tmpl.render, invoice.event.title)
    end

end
