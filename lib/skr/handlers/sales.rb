module Skr

    class Handlers::Sales < Lanes::API::ControllerBase

        attr_reader :invoice

        def create
            if data['credit_card']
                card = ActiveMerchant::Billing::CreditCard.new(data['credit_card'])
                card.validate
                if card.errors.any?
                    return std_api_reply(:create, {errors: card.errors}, success: false)
                end
            else
                return std_api_reply(:create, {errors: {card: 'Unable to charge'}}, success: false)
            end

            unless data['billing_address']
                return std_api_reply(:create, {errors: {billing_address: 'is missing'}}, success: false)
            end
            reply = {}
            Invoice.transaction do
                build_invoice(
                    customer: find_or_create_customer,
                    billing_address_attributes: data['billing_address']
                )
                options = build_reply_options.merge(success: invoice.save, methods: 'total')

                reply = std_api_reply(:create, invoice, options)
                raise ActiveRecord::Rollback if invoice.errors.any?
            end
            begin # we've charged the card at this point and we must show the results page
                email_receipt if invoice.errors.none?
            rescue => e
                Lanes.logger.error "Failed to deliver email for sale #{invoice.visible_id} : #{e}"
            end
            return reply
        end

        def build_invoice(attrs)

            @invoice = Skr::Invoice.new(attrs)
            if (event_id = data.dig('options', 'event_id'))
                invoice.event = Event.find(event_id)
                invoice.form = 'ticket'
            end
            invoice.location = data['location'] ?
                                   Skr::Location.find_by_code(data['location']) :
                                   Skr::Location.default

            invoice.form ||= data.dig('options', 'form')
            if data['options']
                invoice.options ||= {}
                invoice.options.merge!(data['options'])
            end
            (data['skus'] || []).each do | l |
                sku_loc = Skr::SkuLoc
                            .where({ location: invoice.location, sku_id: l['sku_id'] })
                            .first
                invoice.lines << Skr::InvLine.new({
                    sku_loc: sku_loc, qty: l['qty']
                })
            end
            invoice.payments.build(
                amount: invoice.total,
                credit_card: data['credit_card']
            )
            invoice
        end

        def find_or_create_customer
            customer =
                Skr::Customer.find_by_code(data['customer']) ||
                Skr::Customer.joins(:billing_address)
                    .merge( Skr::Address.where( data['billing_address'] ) ).first ||
                Skr::Customer.find_by_name(data['billing_address']['name'])

            unless customer
                customer = Skr::Customer.create!(
                    name: data['billing_address']['name'],
                    billing_address_attributes: data['billing_address']
                )
            end
            customer

        end

        def email_receipt
            mail = Lanes::Mailer.create
            mail.to = invoice.billing_address.email
            if invoice.event && invoice.event.email_from.present?
                mail.from = invoice.event.email_from
            end
            mail.subject = "Your recent purchase from #{Lanes::Extensions.controlling.title}"

            mail.content_type = 'text/html; charset=UTF-8'
            mail.body = email_body
            from = data.dig('email', 'from')
            mail.from = from if from.present?
            mail.deliver
        end

        def email_body
            klass = invoice.event ?
                        Skr::Templates::Mails::EventConfirmation : Skr::Templates::Mails::InvoiceConfirmation
            klass.new(invoice: invoice).render
        end

    end

end
