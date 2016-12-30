class StringCheckNumbers < ActiveRecord::Migration[4.2]
    def change
        change_column :skr_payments, :check_number, :varchar
    end
end
