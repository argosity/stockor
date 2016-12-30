require 'skr/db/migration_helpers'

class CreateSkrVouchers < ActiveRecord::Migration[4.2]
    def change

        create_skr_table "vouchers" do |t|
            t.skr_visible_id
            t.skr_state
            t.skr_reference :vendor,         single: true, null: false
            t.skr_reference :purchase_order, single: true, null: true
            t.skr_reference :terms,          to_table: 'payment_terms'
            t.date     "confirmation_date",  null: true # starts out as non-confirmed
            t.string   "refno"
            t.skr_track_modifications
        end

    end
end
