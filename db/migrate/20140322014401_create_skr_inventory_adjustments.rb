require 'skr/db/migration_helpers'

class CreateSkrInventoryAdjustments < ActiveRecord::Migration
    def change

        create_skr_table "inventory_adjustments" do |t|
            t.skr_visible_id
            t.skr_state
            t.skr_reference :location,  null: false, single: true
            t.skr_reference :reason,    null: false, to_table: 'ia_reasons'
            t.text     "description",   null: false
            t.skr_track_modifications
          end

    end
end
