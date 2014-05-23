require_relative '../skr/core'

# This is a "sham" namespace that only exists so that
# Bundler will pull in the Skr::Core namespace
module Stockor
    module Core
        VERSION = Skr::Core::VERSION
    end
end
