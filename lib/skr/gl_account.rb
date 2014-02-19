module Skr

    # A GlAccount *(short for General Ledger Account)* is used
    # to define each class of items for
    # which money or the equivalent is spent or received.
    class GlAccount < Skr::Model

        validates :name, :description, :presence => true

        # @!attribute description
        #   A short description of the GL Account

        # All the postings that were made on the account.  Summing their amounts will produce the balance
        has_many :postings, :class_name=>'Skr::GlPosting', :foreign_key=>'account_id'

        # A future improvement would be to allow arbitrary account masks.  For now, keep it simple
        # with mandatory 4 characters + 2 char branch code
        validates :number, :presence => true, :numericality=>true, :length=>{ :is=>4 }

        # @return [String] The account number combined with location branch code
        def number_for_location( location )
            self.number + location.gl_branch_code
        end

        def trial_balance
            balance_for( GlPeriod.current )
        end

        def account_mask
            number + '%'
        end

        def balance_for( period, mask = self.account_mask )
            GlPosting.matching( period, account_mask ).sum(:amount)
        end

    end
end
