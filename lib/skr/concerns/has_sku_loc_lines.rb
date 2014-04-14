module Skr
    module Concerns

        module HasSkuLocLines

            extend ActiveSupport::Concern

            module InstanceMethods

                def other_charge_lines
                    self.lines.select{|l| l.sku.is_other_charge? }
                end

                def regular_lines
                    self.lines.reject{|l| l.sku.is_other_charge? }
                end

                def regular_lines_total
                    self.regular_lines.sum{|l|l.total}
                end

                def subtotal
                    self.regular_lines.inject(0){|sum,line| sum + line.total }
                end

                def total
                    if total = self.read_attribute('total')
                        BigDecimal.new(total)
                    elsif self.new_record? || self.association(:lines).loaded?
                        self.lines.inject( BigDecimal.new('0') ){|sum,line| sum += line.total }
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
