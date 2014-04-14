module Skr

    # A transaction is a record of a business event that has financial consequences.
    # It consists of an at least one credit and at least one debit
    # Transactions can be nested, with each level compacting all the entries that were made on it
    #
    #     require 'skr/core'
    #     customer = Customer.find_by_code "MONEYBAGS"
    #     GlTransaction.record( source: invoice, description: "Invoice Example" ) do | transaction |
    #       transaction.location = Location.default # <- could also specify in record's options
    #       Sku.where( code: ['HAT','STRING'] ).each do | sku |
    #           transaction.add_posting( amount: sku.default_price,
    #                                     debit:  sku.gl_asset_account,
    #                                    credit: customer.gl_receivables_account )
    #       end
    #     end
    #
    class GlTransaction < Skr::Model

        is_immutable

        # A Transaction must refer to another record, such as Invoice, Inventory Adjustment, or a Manual Posting.
        belongs_to :source, :polymorphic=>true

        # Each transaction belongs to an accounting period
        belongs_to :period, :class_name=>'GlPeriod', export: true

        has_many :credits, ->{ where({ is_debit: false }) }, class_name: 'GlPosting',
                 extend: Concerns::GlTran::Postings, :foreign_key=>'transaction_id',
                 inverse_of: :transaction, autosave: true, export: { writable: true }

        # Must equal credits, checked by the {#ensure_postings_correct} validation
        has_many :debits, ->{  where({ is_debit: true }) }, class_name: 'GlPosting',
                 extend: Concerns::GlTran::Postings, :foreign_key=>'transaction_id',
                 inverse_of: :transaction, autosave: true, export: { writable: true }

        before_validation :set_defaults
        validate  :ensure_postings_correct
        validates :source, :period,  :set=>true
        validates :description,      :presence=>true


        # Add a debit/credit pair to the transaction with amount
        # @param amount [BigDecimal] the amount to apply to each posting
        # @param debit [GlAccount]
        # @param credit [GlAccount]
        def add_posting( amount: nil, debit: nil, credit: nil )
            self.credits.build( location: @location, is_debit: false,
              account: credit, amount: amount )
            self.debits.build(  location: @location, is_debit: true,
              account: debit,  amount: amount * -1 )
        end

        # Passes the location onto the postings.
        def location=(location)
            @location = location
            each_posting do | posting |
                posting.location = location
            end
        end

        # @yield [GlPosting] each posting associated with the Transaction
        def each_posting
            self.credits.each{ |posting| yield posting }
            self.debits.each{ |posting| yield posting }
        end

        # @return [GlTransaction] the current transaction that's in progress
        def self.current
            glt = Thread.current[:gl_transaction]
            glt ? glt.last : nil
        end

        # Start a new nested GlTransaction
        # When a transaction is created, it can have
        # @return [GlTransaction] new transaction
        # @yield  [GlTransaction] new transaction
        def self.record( attributes = {} )
            Thread.current[:gl_transaction] ||= []
            glt = GlTransaction.new( attributes )
            Thread.current[:gl_transaction].push( glt )
            yield glt
            return Thread.current[:gl_transaction].pop._save_recorded
        end

        # @param owner [Skr::Model]
        def self.push_or_save( owner: nil, amount: nil, debit:nil, credit:nil, options:{} )
            if glt = self.current # we push
                glt.add_posting( amount: amount, debit: debit, credit: credit )
            else
                options.merge!({
                    source: owner,
                    location: options[:location] || owner.location
                })
                glt = GlTransaction.new( options )
                glt.add_posting( amount: amount, debit: debit, credit: credit )
                glt.save
            end
            glt
        end

        # @private
        def _save_recorded
            #save if self.debits.any? || self.credits.any?
            %w{ credits debits }.each{ |assoc| compact( assoc ) }
            self.save
            self
        end

        private

        def compact( assoc_name )
            accounts = self.send( assoc_name ).to_a
            self.send( assoc_name + "=", [] )
            account_numbers = accounts.group_by{ |posting| posting.account_number }
            account_numbers.each do | number, matching |
                amount = matching.sum(&:amount)
                self.send( assoc_name ).build({
                    account_number: number,
                    is_debit: ( assoc_name == "debits" ),
                    amount: amount,
                })
            end
        end

        def ensure_postings_correct
            if debits.total !=  ( -1 * credits.total )
                self.errors.add(:credits, "must equal debits")
                self.errors.add(:debits, "must equal credits")
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

        # def ensure_postings_exist
        #     if self.new_record? and self.postings.empty?
        #         2.times { self.postings.build }
        #     end
        # end

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
