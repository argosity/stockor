require "lanes"
require 'require_all'
require "lanes/access"
require_relative "skr/version"
require_relative "skr/extension"
require_rel "skr/configuration"

# The main namespace for Skr
module Skr
    def self.table_name_prefix
        "skr_"
    end
end

require_rel "skr/concerns/*.rb"
require_rel "skr/model"
require_rel 'skr/models/*.rb'
require_relative "skr/access_roles"
