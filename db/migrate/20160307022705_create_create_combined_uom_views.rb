require 'skr/db/migration_helpers'

class CreateCreateCombinedUomViews < ActiveRecord::Migration[4.2]
    def up
        execute <<-EOS
        create view #{skr_prefix}combined_uom as
          select
            uom.id as skr_uom_id,
            case when size = 1 then code else code||'/'||size end as combined_uom
          from #{skr_prefix}uoms uom
        EOS
    end

    def down
        execute "drop view #{skr_prefix}combined_uom"
    end

end
