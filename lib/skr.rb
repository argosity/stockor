require "lanes"
require 'require_all'
require "lanes/access"
require_relative "skr/version"
require_relative "skr/extension"
require_rel "skr/configuration"
require_relative "skr/string"
require_relative "skr/number"

# The main namespace for Skr
module Skr
    def self.table_name_prefix
        "skr_"
    end

    def self.system_settings
        Lanes::SystemSettings.for_ext('skr')
    end
end

require_relative "skr/templates"
require_rel "skr/templates/**/*.rb"
require_rel "skr/concerns/*.rb"
require_rel "skr/jobs/fresh_books/*.rb"
require_relative "skr/print"
require_relative "skr/model"
require_relative "skr/access_roles"
require_relative "skr/merchant_gateway"
