require 'skr/core/db/migration_helpers'

class CreateSoDetailsView < ActiveRecord::Migration
    def up
        execute <<-EOS
            create view #{skr_prefix}so_amount_details as
                select so.id as sales_order_id,
                to_char(so.order_date,'YYYY-MM-DD') as string_order_date,
                cust.code as customer_code, cust.name as customer_name,
                addr.name as bill_addr_name,
                coalesce( ttls.total,0.0 ) as total,
                coalesce( ttls.num_lines, 0 ) as num_lines,
                coalesce( ttls.other_charge_total, 0 ) as total_other_charge_amount,
                coalesce( ttls.tax_charge_total, 0 ) as total_tax_amount,
                coalesce( ttls.shipping_charge_total, 0 ) as total_shipping_amount,
                coalesce( ttls.total,0.0 ) - coalesce( ttls.other_charge_total, 0.0 ) as subtotal_amount
                from #{skr_prefix}sales_orders so
                join #{skr_prefix}customers cust on cust.id = so.customer_id
                join #{skr_prefix}addresses addr on addr.id = so.bill_addr_id
                left join (
                select
                  sales_order_id,
                  sum(sol.qty*sol.price) as total,
                  sum( case when s.is_other_charge then sol.qty*sol.price else 0 end ) as other_charge_total,
                  sum( case when sol.sku_code = '#{Skr::Core.config.ship_sku_code}' then sol.qty*sol.price else 0 end )
                     as shipping_charge_total,
                  sum( case when sol.sku_code = '#{Skr::Core.config.tax_sku_code}' then sol.qty*sol.price else 0 end )
                     as tax_charge_total,
                  count(sol.*) as num_lines
                from #{skr_prefix}so_lines sol
                join #{skr_prefix}sku_locs sl on sl.id = sol.sku_loc_id
                join #{skr_prefix}skus s on s.id = sl.sku_id
                 group by sales_order_id
                ) ttls on ttls.sales_order_id = so.id
        EOS

        execute <<-EOS
            create view #{skr_prefix}so_allocation_details as
              select sales_order_id, count(*) as number_of_lines, sum(sol.qty_allocated*price) as allocated_total,
                 sum( case when sol.qty_allocated  - sol.qty_canceled - sol.qty_picking > 0 then 1 else 0 end )
                   as number_of_lines_allocated,
                 sum( case when sol.qty_allocated = (sol.qty - sol.qty_canceled - sol.qty_picking)
                   then 1 else 0 end )
                   as number_of_lines_fully_allocated
                 from #{skr_prefix}so_lines sol
                   join #{skr_prefix}sku_locs sl on sl.id = sol.sku_loc_id
                   join #{skr_prefix}skus      s on s.id  = sl.sku_id and s.is_other_charge='f'
                 group by sales_order_id having ( sum ( case when
                   sol.qty_allocated  - sol.qty_canceled - sol.qty_picking > 0 then 1 else 0 end
                 ) ) > 0
        EOS

        execute <<-EOS
            create view #{skr_prefix}so_dailly_sales_history as
              select date_trunc('day', (current_date - days_ago)) as day,
              coalesce( ttls.order_count, 0 ) as order_count,
              coalesce( ttls.line_count, 0  ) as line_count,
              coalesce(ttls.total,0.0) as total
              from generate_series(0, 120, 1) as days_ago
              left join (
                 select
                   count(distinct(sales_order_id)) as order_count,
                   count(*) as line_count,
                   sum(sol.price*sol.qty) as total,
                 date_trunc('day', so.created_at ) as so_date
                 from #{skr_prefix}so_lines sol
                 join #{skr_prefix}sales_orders so on sol.sales_order_id = so.id
                 group by date_trunc('day', so.created_at )
              ) ttls on ttls.so_date = date_trunc('day', (current_date - days_ago))
              order by day desc
        EOS
    end

    def down
        execute "drop view #{skr_prefix}so_amount_details"
        execute "drop view #{skr_prefix}so_allocation_details"
        execute "drop view #{skr_prefix}so_dailly_sales_history"
    end
end
