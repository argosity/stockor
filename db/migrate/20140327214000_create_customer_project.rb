require 'skr/db/migration_helpers'

class CreateCustomerProject < ActiveRecord::Migration
    def change
        create_skr_table :customer_projects do |t|
            t.skr_code_identifier
            t.text :description, :po_num, null: false
            t.skr_reference :sku,      single: true
            t.skr_reference :customer, single: true
            t.jsonb :rates
            t.timestamps null: false
        end
    end
end
