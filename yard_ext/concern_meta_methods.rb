class SkrMetaMethodHandler < YARD::Handlers::Ruby::MethodHandler

    def process
        if group_name
            namespace.groups << group_name unless namespace.groups.include? group_name
        end
    end

    def get_namespace( path )
        ensure_loaded! P( path )
        P( path )
    end

    def get_method( ns )
    end

    def add_to_overview
        ns = get_namespace( concern_path + "::ClassMethods" )
        method = ns.meths.detect{ |nsmethod|  nsmethod.name == method_name }

        namespace.docstring += "\n\n" +
                               "## #{method_title} {#{ns} >>}\n\n" +
                               method.docstring.dup

        method.docstring.tags.each{ |tag|  namespace.docstring.add_tag tag }
    end

    def add_instance_methods
        ns = get_namespace( concern_path + "::InstanceMethods" )
        ns.meths.each do |nsmethod|
            object = YARD::CodeObjects::MethodObject.new(namespace, nsmethod.name )
            object.scope = :instance
            object.explicit = false

            object.docstring = nsmethod.docstring.dup
            register object
        end
    end

    def add_class_methods
        ns = get_namespace( concern_path + "::MixedInClassMethods" )

        ns.meths.each do |nsmethod|
            object = YARD::CodeObjects::MethodObject.new(namespace, nsmethod.name )
            object.scope = :instance
            object.explicit = false

            object.docstring = nsmethod.docstring.dup
            register object
        end
    end

    def method_title
        method_name.to_s.titleize
    end

    def group_name
    end

end
