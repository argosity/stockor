require "lanes"
require 'require_all'
require "lanes/access"
require_relative "skr/version"
require_relative "skr/extension"
require_rel "skr/configuration"
require_relative "skr/string"

# The main namespace for Skr
module Skr
    def self.table_name_prefix
        "skr_"
    end
end

require_rel "skr/concerns/*.rb"
require_relative "skr/print"
require_relative "skr/model"
require_relative "skr/access_roles"
require_rel "skr/builders/*.rb"
