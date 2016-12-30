module Skr

    class EventInvoiceXref < Model

        belongs_to :event, inverse_of: :invoice_xrefs

        belongs_to :invoice, inverse_of: :event_xref

    end

end
