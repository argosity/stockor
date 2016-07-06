module Skr
    module Print

        # finds and generates a pdf verison of a document
        class Form

            def initialize(form, code)
                @template = Template.get(form) ||
                            fail("Unable to find template for #{form}")
                @record   = @template.model.where(hash_code: code).first!
                @latex    = @template.path_for_record(@record)
                unless @latex.exist?
                    fail("Unable to find template type for record")
                end
                Lanes.logger.debug "Printing #{form} #{code} using #{@latex}"
            end

            def as_pdf
                template.to_stringio
            rescue ErbLatex::LatexError => e
                Lanes.logger.warn e.log
                raise
            rescue => e
                Lanes.logger.warn e
                raise
            end

            def as_latex
                template.compile_latex
            end

            def data
                vars = {
                    @template.name.underscore => @record,
                    'root_path' => ::Skr::Print::ROOT
                }
                if @record.respond_to?(:latex_template_variables)
                    vars.merge!(@record.latex_template_variables)
                end
                vars
            end

            def template
                ErbLatex::Template.new(@latex,
                                       data: data,
                                       context: Skr::Print::Context,
                                       layout: ROOT.join('layout.tex.erb'),
                                       partials_path: ROOT.join('partials'),
                                       packages_path: ROOT.join('packages')
                                      )
            end
        end

    end
end
