module Skr

    # A GlAccount *(short for General Ledger Account)* is used
    # to define each class of items for
    # which money or the equivalent is spent or received.
    class GlAccount < Skr::Model

        # @private
        DEFAULT_ACCOUNTS={}

        validates :name, :description, :presence => true

        # @!attribute description
        #   A short description of the GL Account

        # A future improvement would be to allow arbitrary account masks.  For now, keep it simple
        # with mandatory 4 characters + 2 char branch code
        validates :number, :presence => true, :numericality=>true, :length=>{ :is=>4 }

        # @return [GlAccount] the default account for the key from {Skr::Core::Configuration.default_gl_accounts}
        def self.default_for( lookup )
            number = Core.config.default_gl_accounts[ lookup ]
            raise RuntimeError.new("Unkown GL default account lookup code: {lookup}") unless number
            DEFAULT_ACCOUNTS[ lookup ] ||= GlAccount.find_by_number( number )
        end

        # @return [String] the account number combined with location branch code
        def number_for_location( location )
            self.number + location.gl_branch_code
        end

        # @return [String] the account number combined with the default branch code
        def default_number
            self.number + Skr::Core.config.default_branch_code
        end

        # @return [BigDecimal] The balance for the current period
        def trial_balance
            balance_for( GlPeriod.current )
        end

        # @return [String] the account number suitable for querying all branches
        def account_mask
            number + '%'
        end

        # @return [BigDecimal] the balance for a given period
        def balance_for( period, mask = self.account_mask )
            GlPosting.matching( period, account_mask ).sum(:amount)
        end

    end

end
