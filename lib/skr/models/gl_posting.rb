module Skr
    class GlPosting < Skr::Model

        is_immutable

        belongs_to   :gl_transaction

        before_validation  :cache_related_attributes

        validates :gl_transaction,    set: true
        validates :account_number, numericality: true, length: { :is=>6 }
        validates :amount,  numericality: true, presence: true
        validate  :ensure_accounting_validity, on: :create

        scope :applying_to_period, ->(period){ where( '(period <= :period and year = :year) or (year < :year)',
                                                      { period: period.period, year: period.year } ) }
        scope :matching, ->(period, account_mask){
            applying_to_period( period ).where('account_number like ?', account_mask )
        }

        def account=(acct)
            @account = acct
            assign_account_number
        end

        def location=(location)
            @location = location
            assign_account_number
        end

        private

        def assign_account_number
            self.account_number = @account.number_for_location(@location) if @account && @location
        end

        def ensure_accounting_validity
            unless self.gl_transaction.new_record? #postings_create_ok?
                self.errors.add( :gl_transaction, "does not accept new postings" )
            end
            if @account && ! @account.is_active?
                self.errors.add(:account, "is not active")
            end

        end

        def cache_related_attributes
            assign_account_number
            self.year   = gl_transaction.period.year
            self.period = gl_transaction.period.period
        end

    end
end
