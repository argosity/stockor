module Skr

    # Implements the interface for a User model in Stockor
    # This implementation grants access to everything
    class NullUser
        # Used to track created_by and updated_by
        def id
            0
        end
        # @param model [Skr::Model]
        # @param attribute [Symbol]
        # @return [Boolean] Can the User view the model?
        def can_read?( model, attribute=nil)
            true
        end

        # @param model [Skr::Model]
        # @param attribute [Symbol]
        # @return [Boolean] Can the User create and update the model?
        def can_write?(model, attribute=nil)
            true
        end

        # @param model [Skr::Model]
        # @return [Boolean] Can the User delete the model?
        def can_delete?(type, model)
            true
        end
    end
end
