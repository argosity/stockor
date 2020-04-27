require_relative '../lib/stockor-saas/asset'

Lanes::API.routes.draw do

    configure do
        use StockorSaas::Elevator
    end

    get Lanes.config.api_path + '/asset/*',
        &StockorSaas::Asset.getter



end
