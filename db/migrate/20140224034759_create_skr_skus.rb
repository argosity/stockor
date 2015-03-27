require 'skr/db/migration_helpers'

class CreateSkrSkus < ActiveRecord::Migration

    def change

        create_skr_table "skus" do |t|
            t.skr_reference "default_vendor",   null: true,  to_table: 'vendors'
            t.skr_reference "gl_asset_account", null: false, to_table: 'gl_accounts'
            t.string   "default_uom_code",      null: false
            t.string   "code",                  null: false
            t.string   "description",           null: false
            t.boolean  "is_other_charge",       null: false, default: false
            t.boolean  "does_track_inventory",  null: false, default: false
            t.boolean  "can_backorder",         null: false, default: false
            t.skr_track_modifications
        end

        #skr_add_index :
    end

end
