require 'skr/core/db/migration_helpers'

class CreateSkrSoLines < ActiveRecord::Migration
    def change

        create_skr_table "so_lines" do |t|
            t.skr_reference :sales_order, null: false, single: true
            t.skr_reference :sku_loc,     null: false, single: true
            t.skr_currency  "price",      null: false
            t.string   "sku_code",        null: false
            t.string   "description",     null: false
            t.string   "uom_code",        null: false
            t.integer  "uom_size",        null: false, limit: 2
            t.integer  "position",        null: false, limit: 2
            t.integer  "qty",             null: false, default: 0
            t.integer  "qty_allocated",   null: false, default: 0
            t.integer  "qty_picking",     null: false, default: 0
            t.integer  "qty_invoiced",    null: false, default: 0
            t.integer  "qty_canceled",    null: false, default: 0
            t.boolean  "is_revised",      null: false, default: false
            t.skr_track_modifications
          end

    end
end
