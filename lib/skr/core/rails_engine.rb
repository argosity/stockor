module Skr::Core
    class RailsEngine < Rails::Engine
        config.autoload_paths += Dir["#{config.root}/lib/**/"]
    end
end
