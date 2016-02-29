require 'skr/db/migration_helpers'

class CreatePayments < ActiveRecord::Migration
    def change

        create_skr_table :payments do |t|
            t.skr_visible_id
            t.skr_reference :bank_accounts, null: false, single: true
            t.skr_currency  :amount,        null: false
            t.date          :date,          null: false
            t.integer       :check_number,  null: false
            t.skr_reference :vendor,        null: true, single: true
            t.text          :memo
            t.timestamps null: false
        end

    end
end
