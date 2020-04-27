require 'rollbar'
require 'rollbar/middleware/sinatra'

Rollbar.configure do |config|
    config.access_token = '0a6299a7577846c9a55c3c30028e6a55'
    config.disable_monkey_patch = true
    if Lanes::API.const_defined?(:Root)
        Lanes::API::Root.use Rollbar::Middleware::Sinatra
    end
end
