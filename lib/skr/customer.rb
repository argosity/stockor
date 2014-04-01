module Skr

    # Customers are Companies (or individuals) that purchase {Sku}s.
    # They have both a billing and shipping address,
    # a gl account that payments should be applied against, and a payment term.
    #
    class Customer < Skr::Model

        # Common code shared with {Vendor}
        include BusinessEntity

        belongs_to :gl_receivables_account, :class_name=>'GlAccount', export: true

        has_many :sales_orders, inverse_of: :customer

        delegate_and_export  :gl_receivables_account_number

        validates :gl_receivables_account, :set=>true

        private

        def set_defaults
            self.gl_receivables_account ||= GlAccount.default_for( :ar )
        end
    end

end # Skr module
