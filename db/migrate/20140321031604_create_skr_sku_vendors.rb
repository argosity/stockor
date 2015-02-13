require 'skr/db/migration_helpers'

class CreateSkrSkuVendors < ActiveRecord::Migration
    def change

        create_skr_table "sku_vendors" do |t|
            t.skr_reference :sku,              null: false, single: true
            t.skr_reference :vendor,           null: false, single: true
            t.skr_currency  "list_price",      null: false, precision: 15, scale: 2
            t.string   "part_code",            null: false
            t.boolean  "is_active",            null: false, default: true
            t.integer  "uom_size",             null: false, default: 1
            t.string   "uom_code",             null: false, default: 'EA'
            t.decimal  "cost",                 null: false, precision: 15, scale: 2
            t.skr_track_modifications
        end
    end
end
