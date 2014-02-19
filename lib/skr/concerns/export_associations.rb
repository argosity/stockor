module Skr::Concerns

    # @see ClassMethods
    module ExportAssociations
        extend ActiveSupport::Concern

        included do
            class_attribute :exported_associations
        end

        module ClassMethods
            # Mark associations as exported, meaning they can be quered against and optionally written to
            # @param associations [list of Symbols]
            # @option options [Boolean] :writable should the associations accept nested attributes
            # @option options [Boolean] :mandatory should the association be included with it's parent at all times?
            # @option options [Symbol referring to a method, lambda] :limit restrict to Users for whom true is returned
            def export_associations( *associations )
                self.exported_associations ||= {}
                associations.flatten!
                options = associations.extract_options!
                associations.each do | assoc_name |
                    self.exported_associations[ assoc_name.to_sym ] = options
                    if options[:writable]
                        accepts_nested_attributes_for( assoc_name, options.except(:writable, :optional) )
                    end
                    if false == options[:optional]
                        self.export_methods( *assoc_name, { :optional=>false })
                    end
                end
            end

            # If the association is exported it may be queried against and it's data included
            # along with the parent record.  It may not be written to unless the :writable flag
            # was set, in which case it'll be allowed by has_exported_association?
            def has_exported_association?( association, user )
                self.exported_associations &&
                    ( options = self.exported_associations[ association.to_sym ] ) &&
                    evaluate_export_limit( user, :association, association, options[:limit] )
            end

            # Does the association allow writes?  True if the association has been exported
            # and it accepts nested attributes
            def has_exported_nested_attribute?( association, user )
                self.nested_attributes_options[ association.to_sym ] &&
                    self.has_exported_association?( association, user )
            end

        end

    end

end
