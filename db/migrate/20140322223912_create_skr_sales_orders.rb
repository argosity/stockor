require 'skr/core/db/migration_helpers'

class CreateSkrSalesOrders < ActiveRecord::Migration
    def up

        create_skr_table "sales_orders" do |t|
            t.skr_visible_id
            t.skr_reference :customer,  null: false, single: true
            t.skr_reference :location,  null: false, single: true
            t.skr_reference :ship_addr, null: false, to_table: 'addresses'
            t.skr_reference :bill_addr, null: false, to_table: 'addresses'
            t.skr_reference :terms,     null: false, to_table: 'payment_terms'
            t.date     "order_date",    null: false
            t.string   "state",         null: false
            t.string   "po_num"
            t.text     "notes"
            t.boolean  "is_revised",    null: false, default: false
            t.string   "hash_code",     null: false
            t.boolean  "ship_partial",  null: false, default: false
            t.boolean  "is_complete",   null: false, default: false
            t.boolean  "is_tax_exempt"
            t.skr_track_modifications
        end

    end

    def down
        drop_skr_table "sales_orders"
    end
end
