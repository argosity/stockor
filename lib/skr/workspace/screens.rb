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

                def assets_for_directory( directory )
                    url = "/assets/skr/screens/#{directory.basename}"
                    assets = []
                    unless Pathname.glob([ directory.join('*.js'), directory.join('*.coffee')] ).empty?
                        assets << "#{url}.js"
                    end
                    unless Pathname.glob([ directory.join('*.css'), directory.join('*.scss')] ).empty?
                        assets << "#{url}.css"
                    end
                    assets
                end

                def each_definition
                    each_directory do | directory |
                        spec = YAML.safe_load( directory.join('specification.yaml').read )
                        spec['files'] = assets_for_directory(directory)
                        yield spec
                    end
                end
            end
        end
    end
end
