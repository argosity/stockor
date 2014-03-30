require 'skr/core/db/migration_helpers'

class CreateSkrPurchaseOrders < ActiveRecord::Migration
    def change

        create_skr_table "purchase_orders" do |t|
            t.skr_visible_id
            t.skr_reference :vendor,    single: true
            t.skr_reference :location,  single: true
            t.skr_reference :ship_addr, to_table: 'addresses'
            t.skr_reference :terms,     to_table: 'payment_terms'
            t.string   "state",         null: false
            t.boolean  "is_revised",    null: false, default: false
            t.date     "order_date",    null: false
            t.datetime "receiving_completed_at"
            t.skr_track_modifications
        end

    end
end
