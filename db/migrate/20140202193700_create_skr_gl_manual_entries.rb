require 'skr/core/db/migration_helpers'

class CreateSkrGlManualEntries < ActiveRecord::Migration
    def change

        create_skr_table "gl_manual_entries" do |t|
            t.skr_visible_id
            t.text "notes"
            t.skr_track_modifications
          end

    end
end
