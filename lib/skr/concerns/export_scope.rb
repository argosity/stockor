require_relative 'exported_limit_evaluator'

module Skr::Concerns

    # @see ClassMethods
    module ExportScope
        extend ActiveSupport::Concern

        included do
            # scopes that the model has exported.  Not intended for querying directly.
            # The API and interested parties should call {#has_exported_scope?}
            class_attribute :exported_scopes
            extend ExportedLimitEvaluator
        end

        # ### Mark a scope as "exportable"
        #
        # An exported scope is safe for querying by external clients over the API.
        # The scope should always:
        #
        #  * Safely escape data *(should __ALWAYS__ do this anyway, but it bears mentioning again)*
        #  * Be relatively simple and complete quickly.
        #  * Provide value to the client that it cannot obtain by using normal query methods
        module ClassMethods

            def scope(name, body, options={}, &block)
                super(name,body,&block)
                if export = options[:export]
                    export_scope( name, body, limit:( export==true ? nil : export[:limit] ) )
                end
            end

            # Mark scope as query-able by the API.
            # @param name [Symbol,String] Rails will create a class method with this name
            # @param query [lambda] Arel query.  This is passed off to Rail's for setting up the scope.
            # @param limit [Symbol referring to a Class method name, lambda]
            # If given, this will be queried by the API to determining if a given user may call the scope
            # @return nil
            def export_scope( name, query, limit: nil )
                include ExportedLimitEvaluator

                self.exported_scopes ||= Hash.new
                self.exported_scopes[ name.to_sym ] = {
                    scope: self.scope( name, query ),
                    name: name,
                    limit: limit
                }
                nil
            end

            # The api can query this to determine if the scope is safe to be called
            # from the API by [user]
            # @param name [Symbol,String] name of scope
            # @param user [User] who is performing the request.
            #   This is passed off to the method or lambda that was given as the limit  argument in {#export_scope}

            def has_exported_scope?( name, user )
                if self.exported_scopes && ( scope_options = self.exported_scopes[ name.to_sym ] )
                    return evaluate_export_limit( user, :scope, name, scope_options[:limit] )
                else
                    return false
                end
            end

        end
    end
end
