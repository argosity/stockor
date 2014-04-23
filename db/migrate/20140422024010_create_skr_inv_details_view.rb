require 'skr/core/db/migration_helpers'

class CreateSkrInvDetailsView < ActiveRecord::Migration

    def up
      execute <<-EOS.squish
      create view #{skr_prefix}inv_details as
         select
           inv.id as invoice_id,
           so.visible_id as sales_order_visible_id,
           pt.id as pick_ticket_id,
           to_char(so.created_at,'YYYY-MM-DD')   as string_order_date,
           to_char(inv.created_at,'YYYY-MM-DD')  as string_invoice_date,
           cust.code as customer_code, cust.name as customer_name,
           ba.name as bill_addr_name,
           coalesce( ttls.total,0.0 ) as total,
           coalesce( ttls.num_lines, 0 ) as num_lines,
           coalesce( ttls.other_charge_total, 0 ) as total_other_charge_amount,
           coalesce( ttls.total,0.0 ) - coalesce( ttls.other_charge_total, 0.0 ) as subtotal_amount
         from #{skr_prefix}invoices inv
         join #{skr_prefix}customers cust on cust.id = inv.customer_id
         left join #{skr_prefix}addresses ba on ba.id = inv.billing_address_id
         left join #{skr_prefix}sales_orders so on so.id = inv.sales_order_id
         left join #{skr_prefix}pick_tickets pt on pt.id = inv.pick_ticket_id
         left join (
             select
               invoice_id,
               sum(ivl.qty*ivl.price) as total,
               sum( case when s.is_other_charge then ivl.qty*ivl.price else 0 end ) as other_charge_total,
               count(ivl.*) as num_lines
             from #{skr_prefix}inv_lines ivl
             join #{skr_prefix}sku_locs sl on sl.id = ivl.sku_loc_id
             join #{skr_prefix}skus s on s.id = sl.sku_id
             group by invoice_id
          ) ttls on ttls.invoice_id = inv.id
      EOS
    end

    def down
        execute "drop view #{skr_prefix}inv_details"
    end
end
