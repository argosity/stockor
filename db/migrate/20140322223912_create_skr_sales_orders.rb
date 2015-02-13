require 'skr/db/migration_helpers'

class CreateSkrSalesOrders < ActiveRecord::Migration
    def change

        create_skr_table "sales_orders" do |t|
            t.skr_visible_id
            t.skr_reference :customer,         single: true
            t.skr_reference :location,         single: true
            t.skr_reference :shipping_address, to_table: 'addresses'
            t.skr_reference :billing_address,  to_table: 'addresses'
            t.skr_reference :terms,            to_table: 'payment_terms'
            t.date     "order_date",           null: false
            t.string   "state",                null: false
            t.boolean  "is_revised",           null: false, default: false
            t.string   "hash_code",            null: false
            t.boolean  "ship_partial",         null: false, default: false
            t.boolean  "is_complete",          null: false, default: false
            t.string   "po_num"
            t.text     "notes"
            t.hstore   "options", default: {}
            t.skr_track_modifications
        end

    end

end
