require 'skr/db/migration_helpers'

class CreateSkrSkuLocs < ActiveRecord::Migration

    def change

        create_skr_table "sku_locs" do |t|
            t.skr_reference :sku,       null: false, single: true
            t.skr_reference :location,  null: false, single: true
            t.decimal  "mac",            precision: 15, scale: 4, default: 0.0, null: false
            t.integer  "qty",            default: 0,   null: false
            t.integer  "qty_allocated",  default: 0,   null: false
            t.integer  "qty_picking",    default: 0,   null: false
            t.integer  "qty_reserved",   default: 0,   null: false
            t.string   "bin"
            t.skr_track_modifications
        end


    end
end
