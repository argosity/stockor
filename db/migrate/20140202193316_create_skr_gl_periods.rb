require 'skr/core/db/migration_helpers'

class CreateSkrGlPeriods < ActiveRecord::Migration

    def change

        create_skr_table "gl_periods" do |t|
            t.integer  "year",     limit: 2, null: false
            t.integer  "period",   limit: 2, null: false
            t.boolean  "is_locked", default: false, null: false
            t.skr_track_modifications
          end

    end

end
