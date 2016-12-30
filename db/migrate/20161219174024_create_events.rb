require 'skr/db/migration_helpers'

class CreateEvents < ActiveRecord::Migration[5.0]
    def change
        create_skr_table :events do |t|
            t.string  :code, null: false
            t.skr_reference :sku, null: false, single: true
            t.text :artist, :featuring, :info, :venue
            t.datetime :starts_at
            t.timestamps null: false
        end

        create_skr_table :events_invoice_xref do |t|
            t.skr_reference :event,   null: false, single: true
            t.skr_reference :invoice, null: false, single: true
        end

        skr_add_index :events_invoice_xref, :invoice_id
        skr_add_index :events_invoice_xref, :event_id
        skr_add_index :events_invoice_xref, [:event_id, :invoice_id], unique: true
    end
end
