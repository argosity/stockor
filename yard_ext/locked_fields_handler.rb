class LockedFieldsHandler < SkrMetaMethodHandler

    namespace_only
    handles method_call(:locked_fields)

    def process
        super
        params = statement.parameters
        params.pop
        params.map! { |p| p.source.gsub(/\s*:/,'') }

        namespace.docstring += "\n\n" +
                               "## Locked Fields {Skr::Concerns::LockedFields::ClassMethods >>}\n\n" +
                               "The following fields are locked:<ul>"
        params.each do | field |
            namespace.docstring += "<li>#{field}</li>"
        end
        namespace.docstring += "</ul>"
    end

end
