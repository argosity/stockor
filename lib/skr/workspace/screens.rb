require 'yaml'

module Skr
    module Workspace

        module Screens
            class << self

                def each_directory
                    root = Pathname.new(__FILE__).dirname.join('../../../app/assets/screens/skr/screens')
                    root.each_child do | path  |
                        yield path if path.directory?
                    end
                end

                def assets_for_directory(directory)
                    path = "skr/screens/#{directory.basename}"
                    assets = []
                    unless Pathname.glob([ directory.join('*.js'), directory.join('*.coffee')] ).empty?
                        assets << "#{path}.js"
                    end
                    unless Pathname.glob([ directory.join('*.css'), directory.join('*.scss')] ).empty?
                        assets << "#{path}.css"
                    end
                    assets
                end

                def each_definition(sprockets)
                    each_directory do | directory |
                        spec = YAML.safe_load( directory.join('specification.yml').read )
                        spec['files'] = assets_for_directory(directory).map do |path|
                            sprockets.asset_path(path)
                        end
                        yield spec
                    end
                    Definition.each(sprockets) do | definition |
                        spec = definition.specification
                        spec['files'] = definition.asset_file_names.map{ |file| "/assets/#{file}" }
                        yield spec
                    end
                end

            end
        end
    end
end

require_relative 'screens/definition'
