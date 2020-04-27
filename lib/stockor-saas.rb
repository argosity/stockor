require "lanes"
require 'require_all'
require 'apartment'
require_relative "stockor-saas/version.rb"
require_relative "stockor-saas/extension.rb"

# The main namespace for StockorSaas
module StockorSaas

    def self.system_settings
        Lanes::SystemSettings.for_ext('stockor-saas')
    end

end

require_relative "stockor-saas/model"
require_relative "stockor-saas/db"
require_relative "stockor-saas/elevator"
require_relative "stockor-saas/monky-patches"
