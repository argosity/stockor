require 'skr/db/migration_helpers'

class CreateEvents < ActiveRecord::Migration[5.0]
    def change
        create_skr_table :events do |t|
            t.string  :code, null: false
            t.skr_reference :sku, null: false, single: true
            t.text :title, null: false
            t.text :sub_title, :info, :venue, :email_from,
                   :email_signature, :post_purchase_message
            t.datetime :starts_at
            t.integer :max_qty
            t.timestamps null: false
        end

        create_skr_table :event_invoice_xrefs do |t|
            t.skr_reference :event,   null: false, single: true
            t.skr_reference :invoice, null: false, single: true
        end

        skr_add_index :event_invoice_xrefs, :event_id
        skr_add_index :event_invoice_xrefs, [:event_id, :invoice_id], unique: true
    end
end
