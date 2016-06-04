module Skr
    module Print
        class Context < ErbLatex::Context

            def pluralize(count, word)
                count == 1 ? word : word.pluralize
            end


            def get_snippet(name)
                snips = Skr.system_settings['latex_snippets'] || {}
                if name && snips[name]
                    snips[name]
                end
            end

        end
    end
end
