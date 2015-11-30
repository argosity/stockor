module Skr
    module Concerns

        module SO

            module Lines

                def other_charge
                    select{|l| l.sku.is_other_charge? }
                end

                def regular
                    reject{|l| l.sku.is_other_charge? }
                end

                def set_ship_qty
                    each{|l| l.qty_to_ship = l.qty }
                end

                def eq_qty
                    if proxy_association.loaded?
                        inject(0){ | sum, sol | sum + (sol.eq_qty*uom_size) }
                    else
                        sum('qty*uom_size')
                    end
                end

                def eq_qty_allocated
                    if proxy_association.loaded?
                        inject(0){ | sum, sol | sum + (sol.qty_allocated * uom_size) }
                    else
                        sum('qty_allocated*uom_size')
                    end
                end
            end
        end
    end
end
