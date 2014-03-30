module Skr

    # Vendors is a companies you purchase goods and services from.
    # They have both a billing and shipping address,
    # a gl account that payables should be applied against, and a payment term.
    class Vendor < Skr::Model

        # Common code shared with {Customer}
        include BusinessEntity


        belongs_to :gl_payables_account, class_name: 'GlAccount', export: true
        belongs_to :gl_freight_account,  class_name: 'GlAccount', export: true


        delegate_and_export  :gl_payables_account_number
        validates :gl_payables_account, :set=>true

        has_many :sku_vendors

        private

        def set_defaults
            self.gl_payables_account ||= GlAccount.default_for( :ap )
            self.gl_freight_account  ||= GlAccount.default_for( :freight )
        end

    end

end # Skr module

__END__

has_many :purchase_orders, :inverse_of=>:vendor

has_many :vendor_skus, :class_name=>'SkuVendor', :inverse_of=>:vendor
has_many :skus, :through=>:vendor_skus, :inverse_of=>:vendors
