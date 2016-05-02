module Skr
    class SequentialId < Skr::Model
        FUNCTION_NAME="#{Skr.config.table_prefix}next_sequential_id"

        self.primary_key = 'name'

        locked_fields :name, :current_value

        def self.next_for( klass )
            begin
                res=ActiveRecord::Base.connection.raw_connection.exec( "select #{FUNCTION_NAME}( $1 )", [ klass.to_s ] )
                res.getvalue(0,0).to_i
            ensure
                res.clear if res
            end
        end

        def self.set_next( klass, value )
            record = self.find_or_initialize_by(name: klass.to_s)
            return if record.new_record? and 0 == value.to_i
            record.unlock_fields(:current_value) do
                record.current_value = value.to_i
                record.save
            end
        end

    end
end
