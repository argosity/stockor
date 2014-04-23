require 'skr/core/db/migration_helpers'

class CreateSkrPickTickets < ActiveRecord::Migration
    def change

        create_skr_table "pick_tickets" do |t|
            t.skr_visible_id
            t.skr_reference :sales_order, single: true
            t.skr_reference :location,    single: true
            t.date     "shipped_at"
            t.boolean  "is_complete",     default: false
            t.skr_track_modifications
        end

    end
end
