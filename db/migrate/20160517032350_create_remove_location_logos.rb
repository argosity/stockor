class CreateRemoveLocationLogos < ActiveRecord::Migration

    def up
        remove_column :skr_locations, :logo
    end

    def down
        add_column :skr_locations, :logo, :string
    end

end
