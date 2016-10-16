module FixtureHelpers

    def table_rows

        results = super #table_rows_without_custom_autoset_fields
        if model_class
            results[ table_name ].each do | row |
                row['visible_id'] ||= Skr::SequentialId.next_for( model_class ) if model_class.column_names.include?('visible_id')
                row['hash_code' ] = Lanes::Strings.random if model_class.column_names.include?('hash_code')
                row['created_at'] = Time.now if model_class.column_names.include?('created_at')
                row['updated_at'] = Time.now if model_class.column_names.include?('updated_at')
                # 135138680 == "admin"
                row['created_by_id'] ||= 135138680  if model_class.column_names.include?('created_by_id')
                row['updated_by_id'] ||= 135138680 if model_class.column_names.include?('updated_by_id')
            end
        end
        results
    end
end

ActiveRecord::FixtureSet.prepend FixtureHelpers
