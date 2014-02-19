module Skr

    # A transaction is a record of a business event that has financial consequences.
    # It consists of two postings, a debit and a credit.
    class GlTransaction < Skr::Model

        is_immutable

        # A Transaction must refer to another record, such as Invoice, Inventory Adjustment, or a Manual Posting.
        belongs_to :source, :polymorphic=>true

        # Each transaction belongs to an accounting period
        belongs_to :period, :class_name=>'GlPeriod'

        # While the postings are linked using a has_many association, there can only be two postings.
        # The ensure_postings_correct validation makes sure of this.
        has_many :postings, ->{ order('id' ) },
                 :class_name=>'GlPosting', :foreign_key=>'transaction_id',
                 :inverse_of=>:transaction,  :autosave=>true

        # exports for the API
        export_associations :postings, :writable=>true
        export_associations :period,   :optional=>true

        # validations
        before_validation :set_defaults
        validate  :ensure_postings_correct
        validates :source, :period,  :set=>true
        validates :description,      :presence=>true

        # Passes the location onto the postings.
        def location=(location)
            ensure_postings_exist
            self.postings.each{|pst| pst.location = location }
        end

        # set the amount for the transaction
        # the credit = amount, debit = amount * -1
        def amount=(amt)
            ensure_postings_exist
            self.credit.amount = amt
            self.debit.amount  = amt * -1
        end

        # the debit posting
        def debit
            self.postings.first
        end

        # the credit posting
        def credit
            self.postings.last
        end

        private

        def ensure_postings_correct
            if postings.length != 2
                self.errors(:postings,'must have exactly 2: debit and credit')
                return false
            end
            if debit.account_number == credit.account_number
                self.errors.add(:postings,"must not refer to the same account #{credit.account_number}")
                return false
            end
            if debit.amount !=  ( -1 * credit.amount )
                self.errors.add(:postings,"must be for the same amount")
                return false
            end
            true
        end

        def set_defaults
            self.period ||= GlPeriod.current
            if self.description.blank?
                self.description = self.source.description_for_gl_transaction( self )
            end
        end

        def ensure_postings_exist
            if self.new_record? and self.postings.empty?
                2.times { self.postings.build }
            end
        end

    end
end

__END__

# export_join_tables :details
# export_scope :with_details_for, lambda { | acct |
#     acct = acct.gsub(/\D/,'') + '%'
#     cs = "case when details.debit_account_number like '#{acct}' then details.debit_amount " +
#          "when details.credit_account_number like '#{acct}' then details.credit_amount else 0 end"
#     window = "#{cs} as amount, sum(#{cs}) over (order by created_at) as balance"
#     joins('join gl_transaction_details as details on details.gl_transaction_id = gl_transactions.id')
#         .select("gl_transactions.*, details.*, #{window}")
#         .where("debit_account_number like :acct or credit_account_number like :acct", acct: acct)
# }
