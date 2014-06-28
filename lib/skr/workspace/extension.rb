require 'yaml'

module Skr
    module Workspace

        class Extension

            def initialize(sprockets)
            end

            def bootstrap_data
                {}
            end

            def logical_path
                fail "logical_path method must be defined subclasses of Skr::Workspace::Extension"
            end

            def asset_path
                fail "asset_path method must be defined subclasses of Skr::Workspace::Extension"
            end

            def self.each(config)
                self.descendants.each{ |klass| yield klass.new(config) }
            end
        end
    end
end
