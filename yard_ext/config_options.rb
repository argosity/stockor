class ConfigOptionHandler < YARD::Handlers::Ruby::Base
    handles method_call(:config_option)
    namespace_only

    def process

        name = statement.parameters.first.jump(:tsymbol_content, :ident).source
        object = YARD::CodeObjects::MethodObject.new(namespace, name)

        param_size = statement.parameters.size
        default = statement.parameters[ param_size - 2 ]

        object.parameters = [['default',default.source]]

        # modify the object
        object.dynamic = true

        register(object)
        unless object.docstring.has_tag?(:return)
            object.docstring.add_tag YARD::Tags::Tag.new( :return, "defaults to #{default.source}", [ default.type.to_s.sub(/_.*$/,'').capitalize ])
        end
    end
    def get_tag(tag, text, return_classes = [])
        YARD::Tags::Tag.new(tag, text, [return_classes].flatten)
    end

end
