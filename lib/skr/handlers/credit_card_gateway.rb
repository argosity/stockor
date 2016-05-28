require 'ruby-freshbooks'

module Skr::Handlers

    module CreditCardGateway
        class << self

            def get
                Lanes::API::RequestWrapper.with_authenticated_user(
                    role: 'administrator', with_transaction: false
                ) do |user, req|
                    settings = Lanes::SystemSettings.for_ext('skr-ccgateway')
                    req.std_api_reply :get, (settings['credit_card_gateway'] || {})
                end
            end

            def update
                Lanes::API::RequestWrapper.with_authenticated_user(
                    role: 'administrator', with_transaction: false
                ) do |user, req|
                    settings = Lanes::SystemSettings.for_ext('skr-ccgateway')
                    settings['credit_card_gateway'] = req.data
                    settings.persist!
                    req.std_api_reply :save, (settings['credit_card_gateway'] || {})
                end
            end

        end
    end

end
