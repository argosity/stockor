module Skr

    class Payment < Model
        SEQUENTIAL_ID_PREFIX = 'Pmnt-'

        has_visible_id
        has_random_hash_code
        has_gl_transaction

        belongs_to :category,     class_name: 'Skr::PaymentCategory', export: true
        belongs_to :vendor,       class_name: 'Skr::Vendor',          export: true
        belongs_to :bank_account, class_name: 'Skr::BankAccount',     export: true
        belongs_to :location,     class_name: 'Skr::Location',        export: true

        validates :name, :amount, :category, :bank_account, presence: true

        has_one :gl_transaction, class_name: 'Skr::GlTransaction', as: :source

        before_validation :set_defaults, on: :create

        after_save :apply_transaction

        def latex_template_variables
            { 'position' => :absolute }
        end

      private

        def attributes_for_gl_transaction
            { location: location, source: self,
              description: "Payment #{self.visible_id}" }
        end

        def apply_transaction
            credit = vendor ? vendor.gl_payables_account : category.gl_account

            GlTransaction.push_or_save(
                owner: self, amount: amount,
                debit: bank_account.gl_account,
                credit: credit
            )
        end

        def set_defaults
            self.location     ||= Location.default
            self.date         ||= Date.today
            self.check_number ||= SequentialId.next_for(SEQUENTIAL_ID_PREFIX + bank_account.id.to_s)
        end

    end
end
