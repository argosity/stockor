module Skr
    module Workspace

        module Screens

            def self.each_definition
                screens_directory = Pathname.new(__FILE__).dirname.join('../../../app/assets/screens')
                screens_directory.each_child do | screen_directory  |
                    next unless screen_directory.directory?
                    Pathname.glob(screen_directory.join('*.json')).each do | spec |
                        json = ActiveSupport::JSON.decode( spec.read )
                        json["load"] ||= {}
                        json["load"]["location"]="/assets/skr/screens/#{json['id']}"
                        yield json
                    end
                end
            end
        end
    end
end
