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
            self.connection.raw_connection.exec( "update #{table_name} set current_value = $1 where name = $2", [ value, klass.to_s ] )
        end

    end
end
