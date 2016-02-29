require 'skr/db/migration_helpers'

class CreateSkrCustomers < ActiveRecord::Migration
    def change
        create_skr_table "customers" do |t|
            t.skr_code_identifier
            t.skr_reference :billing_address,        null: false, to_table: :addresses
            t.skr_reference :shipping_address,       null: false, to_table: :addresses
            t.skr_reference :terms,                  null: false, to_table: :payment_terms
            t.skr_reference :gl_receivables_account, null: false, to_table: :gl_accounts
            t.skr_currency :credit_limit,            default: 0.0
            t.skr_currency :open_balance,            default: 0.0
            t.boolean  "is_tax_exempt",              null: false, default: false
            t.string   "hash_code",                  null: false
            t.string   "name",                       null: false
            t.text     "notes"
            t.text     "website"
            t.jsonb    "options"
            t.jsonb    "forms"
            t.skr_track_modifications
        end
    end
end
