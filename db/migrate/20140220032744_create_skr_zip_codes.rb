require 'skr/core/db/migration_helpers'

class CreateSkrZipCodes < ActiveRecord::Migration
    def change

        create_skr_table "zip_codes" do |t|
            t.string "code"
            t.string "city"
            t.string "state"
        end

    end
end
