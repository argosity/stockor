require 'skr/db/migration_helpers'


## views and indexes to efficiently answer the query "which invoices/orders have item id XXX ?"

class CreateSkuAssociationsViews < ActiveRecord::Migration[4.2]

    def up

        add_index(:skr_inv_lines, :sku_loc_id)
        add_index(:skr_sku_locs, :sku_id)

        execute <<-EOS
        create view skr_sku_inv_xref as
          select
            skr_inv_lines.invoice_id,
            skr_sku_locs.sku_id
          from skr_inv_lines
            join skr_sku_locs on skr_sku_locs.id = skr_inv_lines.sku_loc_id
        EOS



        add_index(:skr_so_lines, :sku_loc_id)

        execute <<-EOS
        create view skr_sku_so_xref as
          select
            skr_so_lines.sales_order_id as sales_order_id,
            skr_sku_locs.sku_id
          from skr_so_lines
            join skr_sku_locs on skr_sku_locs.id = skr_so_lines.sku_loc_id
        EOS

    end

    def down
        remove_index(:skr_inv_lines, :sku_loc_id)
        remove_index(:skr_sku_locs, :sku_id)
        execute "drop view skr_sku_inv_xref"

        remove_index(:skr_so_lines, :sku_loc_id)

        execute "drop view skr_sku_so_xref"
    end


end
