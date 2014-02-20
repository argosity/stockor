module Skr

    # Vendors is a companies you purchase goods and services from.
    # They have both a billing and shipping address,
    # a gl account that payables should be applied against, and a payment term.
    class Vendor < Skr::Model

        # Common code shared with {Customer}
        include BusinessEntity


        belongs_to :gl_payables_account, :class_name=>'GlAccount'
        export_associations :gl_payables_account

        delegate_and_export  :gl_payables_account_number
        validates :gl_payables_account, :set=>true

        private

        def set_defaults
            self.gl_payables_account ||= GlAccount.find_by_number( Skr::Core.config.default_gl_ap_account_number )
        end

    end

end # Skr module

__END__

has_many :purchase_orders, :inverse_of=>:vendor

has_many :vendor_skus, :class_name=>'SkuVendor', :inverse_of=>:vendor
has_many :skus, :through=>:vendor_skus, :inverse_of=>:vendors
