require 'skr/db/migration_helpers'

class CreateSkrGlAccounts < ActiveRecord::Migration
    def change

        create_skr_table "gl_accounts" do |t|
            t.string   "number",                       null: false
            t.string   "name",                         null: false
            t.text     "description",                  null: false
            t.boolean  "is_active",     default: true, null: false
            t.skr_track_modifications
          end

    end
end
