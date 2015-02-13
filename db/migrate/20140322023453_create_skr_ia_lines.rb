require 'skr/db/migration_helpers'

class CreateSkrIaLines < ActiveRecord::Migration
    def change

        create_skr_table "ia_lines" do |t|
            t.skr_reference :inventory_adjustment,     null: false, single: true
            t.skr_reference :sku_loc,                  null: false, single: true
            t.integer     "qty",                       null: false, default: 1
            t.string      "uom_code",                  null: false, default: 'EA'
            t.integer      "uom_size",                 null: false, default: 1, limit: 2
            t.skr_currency "cost",                     precision: 15, scale: 2 # n.b. the cost may be left null
            t.boolean      "cost_was_set",             null: false, default: false
            t.skr_track_modifications
          end

    end
end
