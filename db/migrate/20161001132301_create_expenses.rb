require 'skr/db/migration_helpers'

class CreateExpenses < ActiveRecord::Migration
    def change

        change_column :skr_expense_categories, :is_active, :boolean, default: true

    end
end
