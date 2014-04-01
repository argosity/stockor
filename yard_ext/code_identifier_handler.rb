class CodeIdentifierHandler < SkrMetaMethodHandler

    namespace_only
    handles method_call(:has_code_identifier)

    def process
        super
        add_to_overview


        params = statement.parameters
        if params.size > 1
            params.pop
            params.detect{ | param |
                param.jump(:hash).source =~ /(:from\s*=>|from:)\s*["':]([^\W]+)/
            }
            namespace.docstring += "\n\nIf left blank, the {#code} field will be set by sending the {##{$2}} field through {Skr::Core::Strings.code_identifier}"
        end

    end

    def concern_path
        "Skr::Concerns::CodeIdentifier"
    end

    def method_name
        :has_code_identifier
    end

    def method_title
        'Has Code Identifier'
    end
end
