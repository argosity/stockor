require 'yaml'

module Skr
    module Workspace
        module Screens

            class Definition

                def initialize(sprockets)
                end

                def self.each(config)
                    self.descendants.each{ |klass| yield klass.new(config) }
                end
            end

        end
    end
end
