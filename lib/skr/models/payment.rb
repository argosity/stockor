module Skr

    # A payment can be for either incoming or outgoing, if incoming must
    # be associated with an Invoice, otherwise a Vendor or PaymentCategory
    class Payment < Model

        SEQUENTIAL_ID_PREFIX = 'Pmnt-'

        has_visible_id
        has_random_hash_code
        has_gl_transaction

        belongs_to :category,     class_name: 'Skr::PaymentCategory', export: true
        belongs_to :vendor,       class_name: 'Skr::Vendor',          export: true
        belongs_to :invoice,      class_name: 'Skr::Invoice',         export: true
        belongs_to :bank_account, class_name: 'Skr::BankAccount',     export: true
        belongs_to :location,     class_name: 'Skr::Location',        export: true

        validates :name, :amount, :bank_account, presence: true

        attr_accessor :credit_card
        whitelist_attributes :credit_card

        has_one :gl_transaction, class_name: 'Skr::GlTransaction', as: :source

        before_validation :set_defaults, on: :create
        before_validation :attempt_charging_provided_card,
                          on: :create, if: :credit_card

        after_save :apply_transaction

        def latex_template_variables
            { 'position' => :absolute }
        end

        def incoming?
            vendor.present?
        end

        def outgoing?
            vendor.present? || category.present?
        end

      private

        def attempt_charging_provided_card
            return unless credit_card.present?

            card = ActiveMerchant::Billing::CreditCard.new(credit_card)
            gw = Skr::MerchantGateway.get
            resp = gw.purchase(amount, card)
            if resp.success?
                metadata['authorization'] = resp.authorization
            else
                errors.add(:credit_card, "purchase failed: #{resp.message}")
            end
        end

        def gl_accounts
            if vendor
                [vendor.gl_payables_account, bank_account.gl_account]
            elsif invoice
                [bank_account.gl_account,
                 invoice.customer.gl_receivables_account]
            else
                [category.gl_account, bank_account.gl_account]
            end
        end

        def apply_transaction
            (credit, debit) = gl_accounts
            GlTransaction.push_or_save(
                owner:  self,  amount: amount,
                debit:  debit, credit: credit
            )
        end

        def set_defaults
            self.location     ||= Location.default
            self.date         ||= Date.today
            if name.blank?
                if self.vendor
                    self.name = vendor.name
                elsif self.invoice
                    self.name = invoice.billing_address.name
                end
            end
            if bank_account && outgoing?
                self.check_number ||= SequentialId.next_for(SEQUENTIAL_ID_PREFIX + bank_account.id.to_s)
            end
            self.bank_account ||= BankAccount.default
        end

    end
end
