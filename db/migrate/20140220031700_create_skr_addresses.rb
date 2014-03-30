require 'skr/core/db/migration_helpers'

class CreateSkrAddresses < ActiveRecord::Migration
    def change

        create_skr_table "addresses" do |t|
            t.string   "name"
            t.string   "email"
            t.string   "phone"
            t.string   "line1"
            t.string   "line2"
            t.string   "city"
            t.string   "state"
            t.string   "postal_code"
            t.skr_track_modifications
          end

    end
end
