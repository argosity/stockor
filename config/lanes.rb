# This file will be loaded if the current extension is the
# one controlling Lanes.
#
# It will not be evaluated if another extension is loading this one
Lanes.configure do | config |
    # You can specify a different initial vew by setting it here
    # It must be set if the "Workspace" extension is disabled in
    # lib/stockor-saas/extension.rb
    # config.root_view = "StockorSaas.Screens.<View Name>"
end

if Lanes.env.production?
    require 'stockor-saas/production-errors'
end

require_relative 'apartment'
require 'stockor-saas/monky-patches'
