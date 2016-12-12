require 'active_merchant'

module Skr

    module MerchantGateway

        class InvalidCard < StandardError
        end

        def self.get
            @gateway || _create_gateway
        end

        def self._create_gateway
            settings = Lanes::SystemSettings.for_ext('skr-ccgateway')['credit_card_gateway'] || {}
            if settings.empty? && ! Lanes.env.production?
                return ActiveMerchant::Billing::BogusGateway.new
            end

            gateway = nil
            if settings['type']
                gateway = ActiveMerchant::Billing.const_get(settings['type'].classify)
            end
            if gateway.nil?
                Lanes.logger.warn("Unable to find gateway class for id #{settings['type']}")
                raise ActiveRecord::RecordNotFound
            end
            gateway.new(settings.except('type').symbolize_keys)
        end

    end

end
