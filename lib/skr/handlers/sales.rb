module Skr

    class Handlers::Sales < Lanes::API::ControllerBase

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

            customer = if data['customer']
                           Skr::Customer.find_by_code(data['customer'])
                       else
                           Skr::Customer.joins(:billing_address)
                               .merge( Skr::Address.where( data['billing_address'] ) ).first
                       end
            unless customer
                customer = Skr::Customer.create!(
                    name: data['billing_address']['name'],
                    billing_address_attributes: data['billing_address']
                )
            end
            attrs = {customer: customer}
            if data['billing_address']
                attrs[:billing_address_attributes] = data['billing_address']
            end

            invoice = Skr::Invoice.new(attrs)
            invoice.location = data['location'] ?
                                   Skr::Location.find_by_code(data['location']) :
                                   Skr::Location.default
            %w{form options}.each do | attr |
                invoice[attr] = data[attr] if data[attr]
            end

            (data['skus'] || []).each do | l |
                sku_loc = Skr::SkuLoc
                            .where({ location: invoice.location, sku_id: l['sku_id'] })
                            .first
                invoice.lines << Skr::InvLine.new({
                    sku_loc: sku_loc, qty: l['qty']
                })
            end

            std_api_reply(:create, invoice, methods: 'total', success: invoice.save)
        end

    end

end
