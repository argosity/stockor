require 'skr/db/migration_helpers'

class CreateSkrUoms < ActiveRecord::Migration[4.2]
    def change

        create_skr_table "uoms" do |t|
            t.skr_reference :sku,  null: false, single: true
            t.skr_currency "price",    null: false, precision: 15, scale: 2
            t.integer      "size",     null: false, default: 1, limit: 2
            t.string       "code",     null: false, default: "EA"
            t.decimal      "weight",   precision: 6,  scale: 1
            t.decimal      "height",   precision: 6,  scale: 1
            t.decimal      "width",    precision: 6,  scale: 1
            t.decimal      "depth",    precision: 6,  scale: 1
            t.skr_track_modifications
        end

    end
end
