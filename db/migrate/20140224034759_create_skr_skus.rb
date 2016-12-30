require 'skr/db/migration_helpers'

class CreateSkrSkus < ActiveRecord::Migration[4.2]

    def change

        create_skr_table "skus" do |t|
            t.skr_reference "default_vendor",   null: true,  to_table: 'vendors'
            t.skr_reference "gl_asset_account", null: false, to_table: 'gl_accounts'
            t.string   "default_uom_code",      null: false
            t.string   "code",                  null: false
            t.string   "description",           null: false
            t.boolean :is_discontinued, :is_other_charge, :does_track_inventory, :can_backorder,
                      null: false, default: false
            t.skr_track_modifications
        end

        #skr_add_index :
    end

end
