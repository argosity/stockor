module Skr::Templates

    module Mails

        class EventConfirmation < InvoiceConfirmation

            def variables
                super.deep_merge(
                    'shop_name'       => Lanes::Extensions.controlling.title,
                    'form_name'       => 'Ticket'.pluralize(invoice.lines.ea_qty),
                    'email_signature' => event.email_signature || 'Thank you!',
                    'event' => {
                        'title'  => event.title,
                        'photo'  => photo_to_json(event.photo),
                        'presents_logo' => photo_to_json(event.presents_logo)
                    },
                )
            end

            def photo_to_json(photo)
                photo.file.map{ |k,v|
                    [ k.to_s, {
                          'url' =>  Lanes.config.api_path + '/asset/' + v.id,
                          'width' => v.width, 'height' => v.height
                      }
                    ]
                }.to_h
            end

            def event
                invoice.event
            end

        end

    end

end
