require 'skr/db/migration_helpers'

class CreateSkrInvLines < ActiveRecord::Migration

    def change
        create_skr_table "inv_lines" do |t|
            t.skr_reference :invoice,     null: false, single: true
            t.skr_reference :sku_loc,     null: false, single: true
            t.skr_reference :pt_line,     null: true, single: true
            t.skr_reference :so_line,     null: true, single: true
            t.skr_reference :time_entry,  null: true, single: true
            t.skr_currency  :price,       null: false
            t.string   "sku_code",        null: false
            t.string   "description",     null: false
            t.string   "uom_code",        null: false
            t.integer  "uom_size",        null: false, limit: 2
            t.integer  "position",        null: false, limit: 2
            t.decimal  "qty",             null: false, precision: 15, scale: 2
            t.boolean  "is_revised",      null: false, default: false
            t.jsonb    "options"
            t.skr_track_modifications
        end
    end

end
