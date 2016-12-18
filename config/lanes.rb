# This file will be loaded as part of Lanes startup.
#
# Extensions are called in load order, so be aware latter extensions may
# override config options specified
Lanes.configure do | config |


end

Lanes.config.get(:environment) do | env |
#    unless Lanes.env.production?
        ActiveMerchant::Billing::Base.mode = :test
#    end
end
