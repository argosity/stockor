require 'liquid'

module Skr

    module Templates

        class LiquidTemplateDefinition < TemplateDefinition


            def extension
                '.' + defined_format.to_s + '.liquid'
            end

            def render
                template.render(variables.stringify_keys)
            end

            def variables
                {}
            end

            def source
                pathname.read
            end

            def template
                @template ||= Liquid::Template.parse(source, :error_mode => :warn)
            end

        end

    end
end
