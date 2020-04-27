class BlankOldFileAssets < ActiveRecord::Migration
    def up
        execute "update assets set file_data = '{}'"
    end

    def down
    end
end
