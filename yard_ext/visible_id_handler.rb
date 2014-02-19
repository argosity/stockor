class VisibleIdHandler < SkrMetaMethodHandler

    namespace_only
    handles method_call(:has_visible_id)

    def process
        super
        add_to_overview
        add_instance_methods

        # we have to do this since our attribute ends in _id and yard-activerecord
        # won't index it
        object = YARD::CodeObjects::MethodObject.new(namespace, "visible_id" )
        object.scope = :instance
        object.explicit = false
        object.docstring.add_tag YARD::Tags::Tag.new(:return, '', 'Integer' )
        register object
        namespace.instance_attributes[:visible_id] = { read: object }

        object = YARD::CodeObjects::MethodObject.new(namespace, 'with_visible_id', :class)
        object.docstring = "Query the visible_id as a string.  " +
                           "Will use an sql like operator if a '%' is present, " +
                           "and equality match otherwise."
        object.docstring.add_tag YARD::Tags::Tag.new(:return, '', [ "Array<#{namespace}>" ] )

    end

    def concern_path
        "Skr::Concerns::VisibleIdIdentifier"
    end

    def method_name
        :has_visible_id
    end
    def method_title
        'Has Visible ID'
    end
end
