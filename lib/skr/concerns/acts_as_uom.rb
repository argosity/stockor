module Skr
    module Concerns

        # @see ClassMethods
        module ActsAsUOM

            extend ActiveSupport::Concern

            module ClassMethods
                def acts_as_uom( opts = {})
                    include InstanceMethods

                    export_methods :ea_qty, :combined_uom, :optional=>false
                end
            end

            module InstanceMethods
                def combined_uom
                    if self.uom_size.nil? || self.uom_code.nil?
                        ''
                    elsif 1 == self.uom_size
                        self.uom_code
                    else
                        "#{self.uom_code}/#{self.uom_size}"
                    end
                end

                def ea_qty
                    self.uom_size * self.qty
                end

                def uom=(uom)
                    self.uom_size = uom.size
                    self.uom_code = uom.code
                end

                def uom
                    Uom.new({ size: self.uom_size, code: self.uom_code })
                end

            end

        end

    end

end
