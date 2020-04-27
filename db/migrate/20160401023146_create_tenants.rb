class CreateTenants < ActiveRecord::Migration
    def change
        create_table :tenants do |t|
            t.string :domain, null: false
            t.string   "name", null: false
            t.string   "email"
            t.string   "phone"
            t.string   "line1"
            t.string   "line2"
            t.string   "city"
            t.string   "state"
            t.string   "postal_code"
            t.timestamps null: false
        end
    end
end
