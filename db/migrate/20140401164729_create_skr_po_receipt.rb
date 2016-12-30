require 'skr/db/migration_helpers'

class CreateSkrPoReceipt < ActiveRecord::Migration[4.2]
    def change
        create_skr_table "po_receipts" do |t|
            t.skr_visible_id
            t.skr_reference :location,       single: true
            t.skr_currency  :freight,        null: false, default: 0.0
            t.skr_reference :purchase_order, single: true, null: false
            t.skr_reference :vendor,         single: true, null: false
            t.skr_reference :voucher,        single: true, null: true
            t.string :refno
            t.skr_track_modifications create_only: true
         end
    end
end
