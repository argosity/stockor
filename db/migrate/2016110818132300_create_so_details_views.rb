require 'skr/db/migration_helpers'


skr = Lanes::Extensions.for_identifier 'skr'
require skr.root_path.join('db/migrate/20140323001446_create_so_details_view.rb').to_s

class CreateSoDetailsViews < CreateSoDetailsView
    def up
        self.down()
        super
    end

end
