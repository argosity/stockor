class ImmutableHandler < SkrMetaMethodHandler

    namespace_only
    handles method_call(:is_immutable)

    def process
        add_to_overview
    end

    def concern_path
        "Skr::Concerns::ImmutableModel"
    end

    def method_name
        :is_immutable
    end
end
