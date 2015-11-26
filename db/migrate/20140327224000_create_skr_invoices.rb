require 'skr/db/migration_helpers'

class CreateSkrInvoices < ActiveRecord::Migration

    def change
        create_skr_table "invoices" do |t|
            t.skr_visible_id
            t.skr_state
            t.skr_reference :terms,            to_table: 'payment_terms'
            t.skr_reference :customer,         single: true
            t.skr_reference :location,         single: true
            t.skr_reference :customer_project, single: true, null: true
            t.skr_reference :sales_order,      single: true, null: true
            t.skr_reference :pick_ticket,      single: true, null: true
            t.skr_reference :shipping_address, to_table: 'addresses'
            t.skr_reference :billing_address,  to_table: 'addresses'
            t.skr_currency  :amount_paid,      null: false, default: 0.0
            t.boolean  "is_tax_exempt",        null: false, default: false
            t.string   "hash_code",            null: false
            t.date     "invoice_date",         null: false
            t.string   "po_num"
            t.text     "notes"
            t.string   "form"
            t.jsonb    "options"
            t.skr_track_modifications
        end
    end

end
