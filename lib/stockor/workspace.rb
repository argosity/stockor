require_relative '../skr/workspace'

# This is a "sham" namespace that only exists so that
# Bundler will pull in the Skr::Workspace namespace
module Stockor
    module Workspace
        VERSION = Skr::Workspace::VERSION
    end
end
