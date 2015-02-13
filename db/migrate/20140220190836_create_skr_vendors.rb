require 'skr/db/migration_helpers'

class CreateSkrVendors < ActiveRecord::Migration
    def change

        create_skr_table "vendors" do |t|
            t.skr_reference :billing_address,     null: false, to_table: :addresses
            t.skr_reference :shipping_address,    null: false, to_table: :addresses
            t.skr_reference :terms,               null: false, to_table: :payment_terms
            t.skr_reference :gl_payables_account, null: false, to_table: :gl_accounts
            t.skr_reference :gl_freight_account,  null: false, to_table: :gl_accounts
            t.string   "code",                    null: false
            t.string   "hash_code",               null: false
            t.string   "name",                    null: false
            t.text     "notes"
            t.string   "account_code"
            t.string   "website"
            t.skr_track_modifications
          end

    end
end
