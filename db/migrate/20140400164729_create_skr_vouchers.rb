require 'skr/core/db/migration_helpers'

class CreateSkrVouchers < ActiveRecord::Migration
    def change

        create_skr_table "vouchers" do |t|
            t.skr_visible_id

            t.skr_reference :vendor,         single: true, null: false
            t.skr_reference :purchase_order, single: true, null: true

            t.skr_reference :terms,          to_table: 'payment_terms'

            t.string   "state",              null: false
            t.string   "refno"

            t.date     "confirmation_date",     null: true # starts out as non-confirmed
            t.skr_track_modifications
        end

    end
end
