require 'skr/core/db/migration_helpers'

class CreateSkrIaReasons < ActiveRecord::Migration
    def change

        create_skr_table "ia_reasons" do |t|
            t.skr_reference :gl_account, null: false, single: true
            t.string   "code",          null: false
            t.string   "description",   null: false
            t.skr_track_modifications
        end

    end
end
