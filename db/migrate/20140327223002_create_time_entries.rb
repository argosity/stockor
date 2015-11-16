require 'skr/db/migration_helpers'

class CreateTimeEntries < ActiveRecord::Migration
    def change
        create_skr_table :time_entries do |t|
            t.skr_reference :customer_project, single: true
            t.references    :lanes_user,  null: false, index: true, foreign_key: true
            t.boolean       :is_invoiced, null: false, default: false
            t.datetime      :start_at,    null: false
            t.datetime      :end_at,      null: false
            t.text          :description, null: false
            t.skr_track_modifications
        end

    end
end
