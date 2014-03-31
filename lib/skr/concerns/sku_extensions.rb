module Skr
    module Concerns

        module Sku

            module Locations
                # Attempt to find a {SkuLoc} record and create it if not found
                def find_or_create_for( location )
                    location_id = location.is_a?(Numeric) ? location : location.id
                    detect{ |l| l.location_id==location_id } || create!({ :location_id=>location_id })
                end
                def default
                    loc_id = Location.default.id
                    detect{ |sl| sl.location_id == loc_id }
                end
            end

            module Vendors
                def default
                    vendid = self.proxy_association.owner.default_vendor_id
                    detect{ |sv| sv.vendor_id == vendid }
                end
                def for_vendor( vendor )
                    vendor_id = vendor.is_a?(Numeric) ? vendor : vendor.id
                    detect{ |v| v.vendor_id==vendor_id }
                end
            end

            module Uoms
                def default
                    code = self.proxy_association.owner.default_uom_code
                    detect{ |uom| code == uom.code }
                end
            end
        end

    end
end
