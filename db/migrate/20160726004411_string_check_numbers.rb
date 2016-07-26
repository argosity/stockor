class StringCheckNumbers < ActiveRecord::Migration
    def change
        change_column :skr_payments, :check_number, :varchar
    end
end
