require 'skr/db/migration_helpers'

class CreateSkrSkuTrans < ActiveRecord::Migration
    def change

        create_skr_table "sku_trans" do |t|
            t.references :origin, :polymorphic => true
            t.skr_reference :sku_loc,        null: false, single: true
            t.skr_currency  "cost",          null: false
            t.string   "origin_description", null: false
            t.integer  "prior_qty",          null: false
            t.decimal  "mac",                null: false, precision: 15, scale: 4
            t.decimal  "prior_mac",          null: false, precision: 15, scale: 4
            t.integer  "qty",                null: false, default: 0
            t.string   "uom_code",           null: false, default: 'EA'
            t.integer  "uom_size",           null: false, default: 1
            t.skr_track_modifications        create_only: true # sku_tran can only be created
          end

    end
end
