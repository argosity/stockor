module Skr::Concerns

    # @see ClassMethods
    module JsonAttributeAccess

        extend ActiveSupport::Concern

        included do
            class_attribute :blacklisted_json_attributes
            class_attribute :whitelisted_json_attributes
        end

        module ClassMethods

            # @param attributes [Array of symbols] attributes that are safe for the API to set
            def whitelist_json_attributes( *attributes )
                options = attributes.extract_options!
                self.whitelisted_json_attributes ||= {}
                attributes.each{|attr| self.whitelisted_json_attributes[ attr.to_sym ] = options }
            end

            # @param attributes [Array of symbols] attributes that are not safe for the API to set
            def blacklist_json_attributes( *attributes )
                options = attributes.extract_options!
                self.blacklisted_json_attributes ||= {}
                attributes.each{|attr| self.blacklisted_json_attributes[ attr.to_sym ] = options }
            end

            # An attribute is allowed if it's white listed
            # or it's a valid attribute and not black listed
            # @param name [Symbol]
            # @param user [UserProxy,User] who is performing request
            def json_attribute_is_allowed?( name, user )
                (self.whitelisted_json_attributes && self.whitelisted_json_attributes.has_key?( name.to_sym ) ) ||
                    (
                        self.attribute_names.include?( name.to_s ) &&
                        ( self.blacklisted_json_attributes.nil? ||
                          ! self.blacklisted_json_attributes.has_key?( name.to_sym )  )
                    )

            end

        end

    end

end
