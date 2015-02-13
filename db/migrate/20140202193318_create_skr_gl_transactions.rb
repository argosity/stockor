require 'skr/db/migration_helpers'

class CreateSkrGlTransactions < ActiveRecord::Migration
    def change

        create_skr_table "gl_transactions" do |t|
            t.skr_reference "period",       to_table: 'gl_periods'
            t.belongs_to    "source",       polymorphic: true
            t.text          "description",  null: false
            t.skr_track_modifications       create_only: true # since it can't be updated
          end

    end
end
