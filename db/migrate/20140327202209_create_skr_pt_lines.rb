require 'skr/core/db/migration_helpers'

class CreateSkrPtLines < ActiveRecord::Migration
    def change

        create_skr_table "pt_lines" do |t|
            t.skr_reference :pick_ticket, single: true
            t.skr_reference :so_line,     single: true
            t.skr_reference :sku_loc,     single: true
            t.skr_currency  "price",      null: false
            t.string   "sku_code",        null: false
            t.string   "description",     null: false
            t.string   "uom_code",        null: false
            t.string   "bin",             null: true
            t.integer  "uom_size",        null: false, limit: 2
            t.integer  "position",        null: false, limit: 2
            t.integer  "qty",             null: false, default: 0
            t.integer  "qty_invoiced",    null: false, default: 0
            t.boolean  "is_complete",     null: false, default: false
        end

    end
end
