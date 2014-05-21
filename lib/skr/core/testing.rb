require 'pathname'

module Skr
    module Core
        module Testing
            def self.fixtures_path
                Pathname.new(__FILE__).dirname.join('testing/fixtures')
            end
        end
    end
end
