module Skr::Concerns

    # @see ClassMethods
    module ExportMethods
        extend ActiveSupport::Concern

        included do

            # methods that the model has exported.  Not intended for querying directly.
            # The API and interested parties should call {#has_exported_method?}
            class_attribute :exported_methods
        end

        module ClassMethods

            # Called by a model to export methods to the API
            # An exported method will be called and it's results returned along with the models
            # JSON representation.
            # @option options [Boolean] :optional if false, the method will always be called and included
            # @option options [Symbol, Array of Symbols] :depends name(s) of associations that should
            #     be pre-loaded before calling method. Intended to prevent N+1 queries
            def export_methods( *method_names )
                method_names.flatten!
                options = method_names.extract_options!
                self.exported_methods ||= {}
                method_names.map do | name |
                    exported_methods[ name.to_sym] = options
                end
            end

            # Convenience method to create a Rails delegation and export the resulting method
            # @example
            #     class Foo < Skr::Model
            #           belongs_to :bar
            #           delegate_and_export :bar_name, :optional=>false
            #     end
            #
            #     foo = Foo.new
            #     foo.bar_name #=> calls foo.bar.name
            #     Foo.has_exported_method?( :bar_name )  #=> true
            #     skr_to_json( foo ) #=> will first load the bar association, then
            #                            call foo.bar_name and include it's result in the JSON
            def delegate_and_export( *names )
                options = names.extract_options!
                names.each do | name |
                    target,field = name.to_s.split(/_(?=[^_]+(?: |$))| /)
                    delegate_and_export_field( target, field, optional: options[:optional], limit: options[:limit] )
                end
            end

            # For situations where the delegate_and_export method guesses wrong on the association and field names
            # @param target [Association] association to delegate to
            # @param field  [Symbol] method on Association to call
            # @param optional [Boolean] should the method be called and results included all the time,
            #                    or only if specifically requested
            # @param limit [Symbol referring to a method, lambda] restrict to Users for whom true is returned
            # @example
            #     class PoLine < Skr::Model
            #           belongs_to :purchase_order
            #           delegate_and_export :purchase_order_visible_id
            #     end
            # would generate a method ``purchase_order_visible_id`` that would call ``purchase_order_visible.id``
            # This would do the right thing:
            #     class PoLine < Skr::Model
            #           belongs_to :purchase_order
            #           delegate_and_export_field :purchase_order, :visible_id
            #     end
            def delegate_and_export_field( target, field, optional: true, limit: nil )
                delegate field, to: target, prefix: target, allow_nil: true
                self.export_methods( "#{target}_#{field}", { depends: target.to_sym,
                                                             optional: optional,
                                                             limit: limit } )
            end

            # Check if the method can be called by user
            def has_exported_method?( name, user )
                if self.exported_methods && ( method_options = self.exported_methods[ name.to_sym ] )
                    return evaluate_export_limit( user, :method, name, method_options[:limit] )
                else
                    return false
                end
            end

            # Retrieve the list of dependent associations for the given methods
            # Also includes methods that were exported as ``optional: false``
            # @param requested_methods [Array] methods that the user has requested be executed and added to the JSON payload
            # @return [Array] list of associations that should be included in query
            def exported_method_dependancies( requested_methods )
                requested_methods.map!(&:to_sym)
                return [] if self.exported_methods.blank?
                depends = self.exported_methods.each_with_object(Array.new) do | kv, result |
                    ( export, options ) = kv
                    if options[:depends] && ( false == options[:optional] || requested_methods.include?(export) )
                        result << options[:depends]
                    end
                end
                depends.uniq
            end
        end


    end

end
