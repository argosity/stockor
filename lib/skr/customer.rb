module Skr

    # Customers are Companies (or individuals) that purchase {Sku}s.
    # They have both a billing and shipping address,
    # a gl account that payments should be applied against, and a payment term.
    #
    class Customer < Skr::Model

        # Common code shared with {Vendor}
        include BusinessEntity

        belongs_to :gl_receivables_account, class_name: 'Skr::GlAccount', export: true

        has_many :sales_orders, inverse_of: :customer
        has_many :invoices,     inverse_of: :customer, listen: { save: :update_balance! }

        delegate_and_export :gl_receivables_account_number

        validates :gl_receivables_account, set: true

        # Updates the amount the customer owes, which is the sum of the amount unpaid on open invoices
        def update_balance!(*)
            update_attributes open_balance: invoices.open_for_customer(self)
                                                    .with_details.sum('details.total')
        end

      private

        def set_defaults
            self.terms                  ||= PaymentTerm.find_by_code(Core.config.customer_terms_code)
            self.gl_receivables_account ||= GlAccount.default_for( :ar )
        end
    end
end # Skr module
