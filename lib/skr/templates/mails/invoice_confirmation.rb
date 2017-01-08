module Skr::Templates

    module Mails

        class InvoiceConfirmation < LiquidTemplateDefinition

            format :html

            attr_reader :invoice

            def initialize(invoice:)
                @invoice = invoice
            end

            def variables
                {
                    'shop_name'       => Lanes::Extensions.controlling.title,
                    'invoice' => {
                        'purchaser_name'   => invoice.billing_address.name,
                        'visible_id'       => invoice.visible_id,
                        'number_of_items'  => invoice.lines.ea_qty.to_i,
                        'pdf_download_url' => invoice.pdf_download_url
                    }
                }
            end

        end

    end

end
