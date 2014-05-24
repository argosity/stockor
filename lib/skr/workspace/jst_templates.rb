module Skr
    module Workspace

        class JstTemplates < Tilt::Template

            self.default_mime_type = 'application/javascript'

            def evaluate(scope, locals, &block)
                name = scope.pathname.basename('.skr')
                "Skr.Templates ['#{name}']=" + Skr::Workspace::EJS.compile(data)
            end

            def prepare;
                # NOOP
            end

        end
    end
end
