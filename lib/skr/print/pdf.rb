module Skr
    module Print

        class PDF

            def initialize(form, code)
                @template = Template.get(form) || raise("Unable to find template for #{form}")
                @record   = @template.model.where(hash_code: code).first!
                @latex    = @template.path_for_record(@record)
                unless @latex.exist?
                    raise("Unable to find template type for record")
                end
                Lanes.logger.debug "Printing #{form} #{code} using #{@latex}"
            end

            def output
                tmpl = ErbLatex::Template.new( @latex,
                                               data: { @template.name => @record },
                                               layout: ROOT.join('layout.tex'),
                                               partials_path: ROOT.join('partials'),
                                               packages_path: ROOT.join('packages')
                                             )
                tmpl.to_stringio
            end
        end

    end
end
