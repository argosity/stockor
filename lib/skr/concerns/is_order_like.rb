module Skr
    module Concerns

        module IsOrderLike
            extend ActiveSupport::Concern

            module InstanceMethods


                # Set's the customer.  It also defaults the terms, addresses,and tax_exempt status to the customer's defaults
                # @param cust [Customer]
                # @return Customer
                def customer=(cust)
                    super
                    self.terms ||= cust.terms
                    self.is_tax_exempt    = cust.is_tax_exempt        if self.is_tax_exempt.nil?
                    self.billing_address  = cust.billing_address.dup  if self.billing_address.nil? and cust.billing_address
                    self.shipping_address = cust.shipping_address.dup if self.shipping_address.nil? and cust.shipping_address
                end

                protected

                def set_order_defaults
                    self.location ||= Location.default
                    self.terms    ||= customer.terms if self.customer
                    true
                end

            end

            module ClassMethods

                def is_order_like
                    self.send :include, InstanceMethods
                    has_sku_loc_lines # pull in the sku_loc_lines module

                    validates_associated :lines

                    before_validation :set_order_defaults, :on=>:create

                end

            end

        end
    end
end
