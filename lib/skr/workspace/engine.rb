module Skr
    module Workspace
        class Engine < ::Rails::Engine
            isolate_namespace Workspace
            initializer "skr.app.assets.precompile" do |app|
                app.config.assets.precompile += %w(skr/workspace.js skr/workspace.css)
                app.config.assets.paths << "templates"
                app.config.assets.paths << "fonts"
                app.assets.register_engine(".skr", ::Skr::Workspace::JstTemplates )

            end
            # path = root.join("skr","workspace","assets")
            # Rails.application.config.assets.paths += [
            #   path.join("images"), path.join("fonts")
            # ]
        end
    end
end
