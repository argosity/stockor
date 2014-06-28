module Skr
    module Workspace
        class Engine < ::Rails::Engine
            isolate_namespace Workspace
            initializer "skr.app.assets.precompile" do |app|
                app.config.assets.precompile += %w(skr/workspace.js skr/workspace.css)
                Screens.each_directory do | directory |
                    app.config.assets.precompile += Screens.assets_for_directory( directory )
                end
#                app.config.assets.paths += %w{ "templates", "fonts", "screens" }
                app.assets.register_engine(".skr", ::Skr::Workspace::JstTemplates )

                Screens::Definition.each(app.config) do | definition |
                    app.config.assets.paths << definition.asset_path
                    app.config.assets.precompile += definition.asset_file_names
                end


                Extension.each(app.config) do | definition |
                    app.config.assets.paths << definition.asset_path
                end

            end
        end
    end
end
