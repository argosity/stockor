require 'skr/db/migration_helpers'

class CreateSkrSequentialIds < ActiveRecord::Migration
    def up
        # rails can suck it here, there's no reason to have a id(int)
        create_skr_table :sequential_ids, :id=>false do |t|
            t.string :name, :null=>false
            t.integer :current_value, :null=>false, :default=>0
        end

        execute "alter table #{Skr.config.table_prefix}sequential_ids add primary key (name)"
        execute <<-EOS
create or replace function #{Skr.config.table_prefix}next_sequential_id( varchar )
returns integer AS '
declare
    next_id integer;
begin
    select current_value into next_id from skr_sequential_ids where name = $1 for update;
    if not found then
        insert into skr_sequential_ids ( name, current_value ) values ( $1, 1 );
        return 1;
    else
        update skr_sequential_ids set current_value = next_id+1 where name = $1;
        return next_id+1;
    end if;
end;
' language plpgsql;
EOS
    end

    def down
        drop_skr_table :sequential_ids
        execute "drop function #{Skr.config.table_prefix}next_sequential_id(varchar)"
    end
end
