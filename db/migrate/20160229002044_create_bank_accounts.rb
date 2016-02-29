require 'skr/db/migration_helpers'

class CreateBankAccounts < ActiveRecord::Migration
    def change

        create_skr_table :bank_accounts do |t|
            t.text :code,           null: false
            t.text :name,           null: false
            t.text :description
            t.text :routing_number
            t.text :account_number
            t.skr_reference :address,    null: false, to_table: :addresses
            t.skr_reference :gl_account, null: false, to_table: :gl_accounts
            t.timestamps null: false
        end

    end
end
