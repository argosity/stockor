module Skr
    module Concerns

        module PT

            module Lines

                def set_ship_qty
                    each{|l| l.qty_to_ship = l.qty }
                end

                def ea_picking_qty
                    if proxy_association.loaded?
                        inject(0){ | sum, ptl | sum+(ptl.qty*ptl.uom_size) unless ptl.is_complete? }
                    else
                        where( is_complete: false ).sum('qty*uom_size')
                    end
                end
            end
        end
    end
end
