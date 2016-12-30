class CreateRemoveLocationLogos < ActiveRecord::Migration[4.2]

    def up
        remove_column :skr_locations, :logo
    end

    def down
        add_column :skr_locations, :logo, :string
    end

end
