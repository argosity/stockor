module Skr
    module Concerns

        module INV

            module Payments
                def total
                    if proxy_association.loaded?
                        inject(0){ | sum, pymnt | sum+pymnt.amount }
                    else
                        sum('amount')
                    end
                end

            end

            module Lines

                def other_charge
                    select{|l| l.sku.is_other_charge? }
                end

                def regular
                    reject{|l| l.sku.is_other_charge? }
                end

                def product
                    reject{|l| l.time_entry }
                end

                def time_entry
                    select{|l| l.time_entry }
                end

                def from_pick_ticket!
                    proxy_association.owner.pick_ticket.lines.each do | line |
                        build({ pt_line: line, qty: line.qty_to_ship })
                    end
                end

                def from_sales_order!
                    proxy_association.owner.sales_order.lines.each do | line |
                        build({ so_line: line, qty: line.qty_allocated })
                    end
                end

                def ea_qty
                    if proxy_association.loaded?
                        inject(0){ | sum, il | sum+(il.qty*il.uom_size) }
                    else
                        sum('qty*uom_size')
                    end
                end

            end

        end
    end
end
