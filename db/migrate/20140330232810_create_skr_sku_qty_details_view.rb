require 'skr/db/migration_helpers'

class CreateSkrSkuQtyDetailsView < ActiveRecord::Migration[4.2]
    def up
        execute <<-EOS
        create view #{skr_prefix}sku_qty_details as
           select
               s.id as sku_id,
               sl_ttl.qty as qty_on_hand,
               coalesce( sol_ttl.qty, 0 ) as qty_on_orders,
               coalesce( pol_ttl.qty, 0 ) as qty_incoming
             from #{skr_prefix}skus s
             join (
               select sum(qty) as qty, sku_id
               from #{skr_prefix}sku_locs sl group by sku_id
             ) sl_ttl on sl_ttl.sku_id = s.id

             left join (
               select
                 s.id as sku_id,
                 sum( ( sol.qty - sol.qty_canceled ) * sol.uom_size ) as qty
               from #{skr_prefix}so_lines sol
               join #{skr_prefix}sales_orders so on so.id = sol.sales_order_id
                  and so.state not in (5,10) -- complete, canceled
               join #{skr_prefix}sku_locs sl on sl.id = sol.sku_loc_id
               join #{skr_prefix}skus s on s.id = sl.sku_id
               group by s.id
             ) sol_ttl on sol_ttl.sku_id = s.id

             left join (
               select
                 s.id as sku_id,
                 sum( ( pol.qty - pol.qty_canceled ) * pol.uom_size ) as qty
               from #{skr_prefix}po_lines pol
               join #{skr_prefix}purchase_orders po on po.id = pol.purchase_order_id
                  and po.state not in (5,15) -- received, canceled
               join #{skr_prefix}sku_locs sl on sl.id = pol.sku_loc_id
               join #{skr_prefix}skus s on s.id = sl.sku_id
               group by s.id
             ) pol_ttl on pol_ttl.sku_id = s.id

        EOS
    end

    def down
        execute "drop view #{skr_prefix}sku_qty_details"
    end
end
