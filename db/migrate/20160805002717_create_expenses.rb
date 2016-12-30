require 'skr/db/migration_helpers'

class CreateExpenses < ActiveRecord::Migration[4.2]
    def up

        create_skr_table :expense_categories do |t|
            t.skr_code_identifier
            t.string :name, null: false
            t.boolean :is_active, null: false, default: true
            t.skr_reference :gl_account, null: false, single: true
            t.skr_track_modifications
        end

        create_skr_table(:expense_entries) do |t|
            t.column :uuid, 'uuid', null: false
            t.text :name, null: false
            t.text :memo
            t.timestamp :occured, null: false
            t.jsonb :metadata, default: {}
            t.skr_track_modifications create_only: true
        end
        skr_add_index :expense_entries, :uuid, unique: true

        create_skr_table(:expense_entry_categories) do |t|
            t.skr_reference :category, to_table: 'expense_categories', single: true
            t.skr_reference :entry,    to_table: 'expense_entries',    single: true
            t.skr_currency :amount, null: false
        end
        skr_add_index :expense_entry_categories, :entry_id, unique: false

        execute <<-EOS
          create or replace view skr_expense_entry_details as
          select
            xref.expense_entry_id,
            array_agg(xref.gl_transaction_id) filter (where xref.gl_transaction_id is not NULL) as gl_transaction_ids,
            array_agg(xref.category_id) as category_ids,
            sum(amount) as category_total,
            json_agg(row_to_json(
                (select t from (select category_id, amount, balance) as t(category_id, amount, balance))
              )
            ) category_list
          from (
            select
              entry.id as expense_entry_id,
              gl.id as gl_transaction_id,
              category_id, ec.amount,
              sum(amount) over (partition by category_id order by occured) as balance
            from
              skr_expense_entries entry
            left join skr_gl_transactions gl on
              gl.source_type='Skr::ExpenseEntry' and gl.source_id = entry.id
            join
              skr_expense_entry_categories ec on entry.id = ec.entry_id
          ) as xref
          group by expense_entry_id
        EOS
    end

    def down
        execute "drop view skr_expense_entry_details"
        drop_skr_table :expense_entry_categories
        drop_skr_table :expense_categories
        drop_skr_table :expense_entries
    end
end
