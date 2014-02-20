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
require_relative "core/configuration"
if defined?(::Rails)
    require_relative "core/skr/engine"
end
require_relative "core/db"
require_relative "core/strings"
require_relative "core/numbers"
require_relative "concerns/all"
require_relative "validators/all"
require_relative "model"
require_relative "user_proxy"

require_relative "sequential_id"

## GL
require_relative "gl_account"
require_relative "gl_period"
require_relative "gl_transaction"
require_relative "gl_posting"
require_relative "gl_manual_entry"

require_relative "location"
require_relative "payment_term"

require_relative "zip_code"
require_relative "address"

require_relative "business_entity"
require_relative "vendor"
require_relative "customer"
