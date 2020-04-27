class ConvertAssetsToShrine < ActiveRecord::Migration
    def change
        rename_column :assets, :metadata, :file_data
        remove_column :assets, :file, :string
    end
end
