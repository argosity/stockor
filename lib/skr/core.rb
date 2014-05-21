require 'active_record'

module Skr
    module Core
    end
    module Concerns
    end
    module Validators
    end
end

require_relative "core/version"
require_relative "core/logger"
require_relative "core/testing"
require_relative "core/standard_pricing_provider"
require_relative "core/configuration"
if defined?(::Rails)
    require_relative "core/rails_engine"
end
require_relative "core/db"
require_relative "core/strings"
require_relative "core/numbers"
require_relative "concerns/all"
require_relative "validators/all"
require_relative "model"
require_relative "user_proxy"
require_relative "sequential_id"

require 'require_all'
require_rel '*.rb'
