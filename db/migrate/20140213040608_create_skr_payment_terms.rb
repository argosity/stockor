require 'skr/db/migration_helpers'

class CreateSkrPaymentTerms < ActiveRecord::Migration[4.2]
    def change

        create_skr_table "payment_terms" do |t|
            t.skr_code_identifier
            t.integer  "days",             null: false, :default=>0
            t.string   "description",      null: false
            t.integer  "discount_days"
            t.string   "discount_amount"
            t.skr_track_modifications
        end

    end
end
