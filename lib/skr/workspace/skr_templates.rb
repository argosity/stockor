# Stockor templates compiler
#
# This is a hacked together version of Sam Stephenson's Eco
# project for embedded coffeescript templates.
#
# Our version has the various helper functions pre-loaded
# so the templates themselves are smaller in size.
# and also includes a "h" helper namespace

require 'pathname'

module Skr
    module Workspace

        module EJSSource
            class << self
                def path
                    @path ||=  Pathname.new(__FILE__).dirname.join('eco.js')
                end

                def contents
                    @contents ||= path.read
                end

                def combined_contents
                    [CoffeeScript::Source.contents, contents].join(";\n")
                end

                def context
                    @context ||= ExecJS.compile(combined_contents)
                end

                def compile(template)
                    template = template.read if template.respond_to?(:read)
                    context.call("eco.precompile", template, 'Skr.TemplateWrapper','Skr.View.Helpers')
                end

            end
        end


        class JstTemplates < Tilt::Template

            self.default_mime_type = 'application/javascript'

            def evaluate(scope, locals, &block)
                "Skr.Templates['#{scope.logical_path}']=" + EJSSource.compile(data)
            end

            def prepare;
                # NOOP
            end

        end
    end
end
