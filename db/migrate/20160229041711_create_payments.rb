require 'skr/db/migration_helpers'

class CreatePayments < ActiveRecord::Migration
    def change

        create_skr_table :payment_categories do |t|
            t.string  :code, null: false
            t.string  :name, null: false
            t.skr_reference :gl_account, null: false, to_table: :gl_accounts
            t.timestamps null: false
        end

        create_skr_table :payments do |t|
            t.skr_visible_id

            t.skr_reference :bank_account, null: false, single: true
            t.skr_reference :category,     null: false, single: true,
                            to_table: 'payment_categories'
            t.skr_reference :vendor,       null: true,  single: true
            t.skr_reference :location,     null: false, single: true

            t.string        :hash_code,    null: false
            t.skr_currency  :amount,       null: false
            t.date          :date,         null: false
            t.integer       :check_number, null: false
            t.text          :name,         null: false
            t.text          :address, :notes

            t.timestamps null: false
        end

    end
end
