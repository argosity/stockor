module Skr::Concerns

    module ExportJoinTables

        extend ActiveSupport::Concern

        included do
            class_attribute :exported_join_tables
        end

        module ClassMethods
            # Mark a joined table as safe to be included in a query
            # Primarily used for joining a model to a view for access to summarized data
            def export_join_tables( *tables )
                include ExportedLimitEvaluator
                self.exported_join_tables ||= []
                tables.flatten!
                options = tables.extract_options!
                tables.each do | join_name |
                    self.exported_join_tables << {
                        name: join_name,
                        limit: options[:limit]
                    }
                end

            end

            # Has the join been marked as safe?
            def has_exported_join_table?( name, user )
                self.exported_join_tables && self.exported_join_tables.detect{ | join |
                    join[:name] == name && evaluate_export_limit( user, :join, join[:name], join[:limit] )
                }
            end

        end
    end

end
