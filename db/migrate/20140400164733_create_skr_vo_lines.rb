require 'skr/core/db/migration_helpers'

class CreateSkrVoLines < ActiveRecord::Migration
    def change
        create_skr_table "vo_lines" do |t|
            t.skr_reference :voucher,        null: false, single: true
            t.skr_reference :sku_vendor,     null: false, single: true
            t.skr_reference :po_line,        null: true,  single: true
            t.string   "sku_code",           null: false
            t.string   "part_code",          null: false
            t.string   "description",        null: false
            t.string   "uom_code",           null: false
            t.integer  "uom_size",           null: false, limit: 2
            t.integer  "position",           null: false, limit: 2
            t.integer  "qty",                null: false, default: 0
            t.skr_currency  "price",         null: false
            t.skr_track_modifications
        end

    end
end
