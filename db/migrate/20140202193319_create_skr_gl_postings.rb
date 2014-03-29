require 'skr/core/db/migration_helpers'

class CreateSkrGlPostings < ActiveRecord::Migration
    def change
        create_skr_table "gl_postings" do |t|
            t.skr_reference :transaction,      to_table: 'gl_transactions'
            t.string       "account_number",   null: false
            t.skr_currency "amount",           null: false
            t.boolean      "is_debit",         null: false
            t.integer      "year",             null: false, limit: 2
            t.integer      "period",           null: false, limit: 2
            t.skr_track_modifications          create_only: true # since it can't be updated
        end
        skr_add_index :gl_postings, [:period,:year,:account_number]
    end
end
