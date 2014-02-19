require 'skr/core/db/migration_helpers'

class CreateSkrLocations < ActiveRecord::Migration
    def change

        create_skr_table "locations" do |t|
            t.skr_code_identifier
            t.string   "name",           null: false
            t.boolean  "is_active",      null: false, default: true
            t.string   "gl_branch_code",
                       default: Skr::Core.config.default_branch_code,
                       null: false,
                       limit: 2
            t.skr_track_modifications
          end

    end
end
