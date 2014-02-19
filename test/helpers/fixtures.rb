module FixtureHelpers

    extend ActiveSupport::Concern

    included do
        alias_method_chain :table_rows, :custom_autoset_fields
    end

    def table_rows_with_custom_autoset_fields
        results = table_rows_without_custom_autoset_fields
        if model_class
            results[ table_name ].each do | row |
                row['visible_id'] = Skr::SequentialId.next_for( model_class ) if model_class.column_names.include?('visible_id')
                row['hash_code' ] = Skr::String.random if model_class.column_names.include?('hash_code')
                row['created_at'] = Time.now if model_class.column_names.include?('created_at')
                row['updated_at'] = Time.now if model_class.column_names.include?('updated_at')
                row['created_by_id'] = 593363170  if model_class.column_names.include?('created_by_id')
                row['updated_by_id'] = 593363170 if model_class.column_names.include?('updated_by_id')
            end
        end
        results
    end
end

ActiveRecord::FixtureSet.send :include, FixtureHelpers
