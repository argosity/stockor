require 'skr/db/migration_helpers'

class CreateSkrSkuLocDetailsView < ActiveRecord::Migration
    def up

        execute <<-EOS
        create view #{skr_prefix}sku_loc_details as
          select
            sl.id as sku_loc_id,
            s.code as sku_code,
            s.description as sku_description,
            s.default_uom_code,
            uom.id as default_uom_id,
            coalesce( uom.size, 1) as default_uom_size,
            coalesce(uom.price, 0.0) as default_price,
            v.code as vendor_code, v.name as vendor_name,
            sv.part_code as vendor_part_code,
            sv.cost as purchase_cost
          from #{skr_prefix}sku_locs sl
            join #{skr_prefix}skus s on s.id=sl.sku_id
            left join #{skr_prefix}uoms uom on uom.sku_id = s.id and uom.code = s.default_uom_code
            join #{skr_prefix}vendors v on s.default_vendor_id = v.id
            join #{skr_prefix}sku_vendors sv on sv.vendor_id = v.id and sv.sku_id=s.id
        EOS
    end

    def down
        execute "drop view #{skr_prefix}sku_loc_details"
    end

end
