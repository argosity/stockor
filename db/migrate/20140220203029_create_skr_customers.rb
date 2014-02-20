require 'skr/core/db/migration_helpers'

class CreateSkrCustomers < ActiveRecord::Migration
    def change

        create_skr_table "customers" do |t|
            t.skr_reference :billing_address,        null: false, to_table: :addresses
            t.skr_reference :shipping_address,       null: false, to_table: :addresses
            t.skr_reference :terms,                  null: false, to_table: :payment_terms
            t.skr_reference :gl_receivables_account, null: false, to_table: :gl_accounts
            t.string   "code",                       null: false
            t.string   "hash_code",                  null: false
            t.string   "name",                       null: false
            t.text     "notes"
            t.text     "website"
            t.boolean  "ship_partial",               null: false, default: false
            t.boolean  "is_tax_exempt"
            t.skr_track_modifications
          end

    end
end
