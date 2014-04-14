module Skr
    module Concerns

        module IsOrderLike
            extend ActiveSupport::Concern

            module InstanceMethods

                protected

                def set_defaults
                    self.location ||= Location.default
                    self.terms    ||= customer.terms
                    true
                end

            end

            module ClassMethods

                def is_order_like
                    self.send :include, InstanceMethods
                    has_sku_loc_lines # pull in the sku_loc_lines module
                    validates_associated :lines
                    export_methods :total
                    before_validation :set_defaults, :on=>:create
                end

            end

        end
    end
end
