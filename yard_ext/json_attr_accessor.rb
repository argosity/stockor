class JsonAttrAccessorHandler < SkrMetaMethodHandler

    namespace_only
    handles method_call(:json_attr_accessor)

    def process

        call_params.each do | method_name |
            method_definition = namespace.instance_attributes[method_name.to_sym] || {}

            { read: method_name, write: "#{method_name}=" }.each do |(rw, name)|
                rw_object = register YARD::CodeObjects::MethodObject.new(namespace, name)
                rw_object.docstring.add_tag YARD::Tags::Tag.new(:return, "Returns the value of attribute #{method_name}", 'Object' )
                rw_object.dynamic = true
                method_definition[rw] = rw_object
            end
            namespace.instance_attributes[method_name.to_sym] = method_definition
        end

    end

end
