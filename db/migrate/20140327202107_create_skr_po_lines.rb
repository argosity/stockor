require 'skr/db/migration_helpers'

class CreateSkrPoLines < ActiveRecord::Migration[4.2]
    def change

        create_skr_table "po_lines" do |t|
            t.skr_reference :purchase_order, null: false, single: true
            t.skr_reference :sku_loc,        null: false, single: true
            t.skr_reference :sku_vendor,     null: false, single: true
            t.string   "part_code",          null: false
            t.string   "sku_code",           null: false
            t.string   "description",        null: false
            t.string   "uom_code",           null: false
            t.integer  "uom_size",           null: false, limit: 2
            t.integer  "position",           null: false, limit: 2
            t.integer  "qty",                null: false, default: 0
            t.integer  "qty_received",       null: false, default: 0
            t.integer  "qty_canceled",       null: false, default: 0
            t.skr_currency  "price",         null: false
            t.boolean  "is_revised",         null: false, default: false
            t.skr_track_modifications
        end

    end
end
