module Skr

    module Templates

        class TemplateDefinition

            class_attribute :defined_format

            def self.format(fmt)
                self.defined_format = fmt
            end

            def pathname
                ::Skr::Templates::ROOT.join(
                    self.class.to_s.remove(/^Skr::Templates::/).underscore + self.extension
                )
            end

            def extension
                '.' + defined_format.to_s
            end

        end

    end

end
