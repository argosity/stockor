require 'skr/db/migration_helpers'

class CreateSkrLocations < ActiveRecord::Migration[4.2]
    def change

        create_skr_table "locations" do |t|
            t.skr_code_identifier
            t.string   "name",           null: false
            t.skr_reference :address,    null: false, single: true
            t.boolean  "is_active",      null: false, default: true
            t.string   "gl_branch_code",
                       default: Skr.config.default_branch_code,
                       null: false,
                       limit: 2
            t.string   "logo"
            t.jsonb    "options"
            t.skr_track_modifications
          end

    end
end
