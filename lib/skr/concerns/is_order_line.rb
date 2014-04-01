module Skr
    module Concerns

        module IsOrderLine
            extend ActiveSupport::Concern

            module InstanceMethods
                def uom_record
                    if self.association(:sku).loaded? && self.sku.association(:uoms).loaded?
                        self.sku.uoms.detect{|uom| uom.code == self.uom_code }
                    else
                        self.sku.uoms.where({ code: self.uom_code }).first
                    end
                end

                def ea_qty
                    self.qty*self.uom_size
                end

                def is_other_charge?
                    self.sku.is_other_charge?
                end

                def total
                    self.price * self.qty
                end

                private

                def ensure_sku_does_not_change
                    errors.add(:sku, "can not be updated") if changes['sku_code']
                    if change = changes['sku_loc_id']
                        # allow if the sku_id is the same on both old & new locations
                        unless 1 == SkuLoc.where( id: change ).pluck('sku_id').uniq.length
                            errors.add(:sku, "must be the same in both locations") if sku_code_changed?
                        end
                    end
                end
            end

            module ClassMethods

                def is_order_line( options = {} )
                    self.send :include, InstanceMethods

                    validate  :ensure_sku_does_not_change, :on=>:update

                    if options[:parent]
                        before_create do
                            self.position ||= ( self.send(options[:parent]).lines.maximum(:position) || 0 ) + 1
                        end
                    end

                    export_methods :total, :optional=>false

                end


            end

        end

    end
end
