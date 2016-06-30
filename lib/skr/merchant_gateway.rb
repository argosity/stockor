require 'active_merchant'

module Skr

    module MerchantGateway

        class InvalidCard < StandardError
        end

        def self.get
            @gateway || _create_gateway
        end

        def self._create_gateway
            unless Lanes.env.production?
                return ActiveMerchant::Billing::BogusGateway.new
            end
            settings = Lanes::SystemSettings.for_ext('skr-ccgateway')['credit_card_gateway'] || {}
            gateway = nil
            if settings['type']
                gateway = ActiveMerchant::Billing.const_get(settings['type'].classify)
            end
            if gw.nil?
                Lanes.logger.warn("Unable to find gateway class for id #{settings['type']}")
                raise ActiveRecord::RecordNotFound
            end
            gateway.new(settings.except('type'))
        end

        def purchase(amount, card)
            raise InvalidCard.new(credit_card.validate) unless credit_card.validate.empty?
            gw.purchase(amount, card)
        end

    end

end
