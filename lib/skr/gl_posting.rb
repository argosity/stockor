module Skr
    class GlPosting < Skr::Model

        is_immutable

        belongs_to   :account,     :class_name=>'GlAccount'
        belongs_to   :transaction, :class_name=>'GlTransaction'
        before_save  :cache_related_attributes

        validates :transaction,    :set=>true
        validates :account_number, :presence => true, :numericality=>true, :length=>{ :is=>6 }
        validates :amount,  :numericality=>true, :presence=>true
        validate  :ensure_accounting_validity, :on=>:create

        scope :applying_to_period, ->(period){ where( '(period <= :period and year = :year) or (year < :year)',
                                                      { period: period.period, year: period.year } ) }

        scope :matching, ->(period, account_mask){
            applying_to_period( period ).where('account_number like ?', account_mask )
        }


        def location=(loc)
            @location = loc
            self.account_number = self.account.number_for_location( loc ) if self.account
        end

        def location
            @location ||= Location.default
        end

        def account=(acct)
            super(acct)
            self.account_number = acct.number_for_location( self.location )
        end

        private

        def ensure_accounting_validity
            # Don't allow it to be added onto an existing transaction
            if transaction.postings.count == 2
                self.errors.add(:transaction, "can only have two postings")
            end
            unless self.account.is_active?
                self.errors.add(:account, "is not active")
            end
            if transaction.period.is_locked?
                self.errors.add(:period, "is locked")
            end
        end

        def cache_related_attributes
            self.account_number = self.account.number_for_location(location) if self.account
            self.year   = transaction.period.year
            self.period = transaction.period.period
        end

    end
end
