module Skr
    module Concerns

        module HasSkuLocLines

            extend ActiveSupport::Concern

            module InstanceMethods

                def total
                    if total = self.read_attribute('total')
                        BigDecimal.new(total)
                    elsif self.new_record? || self.association(:lines).loaded?
                        self.lines.inject( BigDecimal.new('0') ){|sum,line| sum += line.extended_price }
                    else
                        BigDecimal.new( self.lines.sum('price*qty') )
                    end
                end
            end

            module ClassMethods

                def has_sku_loc_lines
                    self.send :include, InstanceMethods
                    export_methods :total
                end
            end

        end
    end
end
