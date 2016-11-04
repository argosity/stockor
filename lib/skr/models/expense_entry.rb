module Skr

    class ExpenseEntry < Model

        self.primary_key = 'id'

        has_one :gl_transaction, class_name: 'Skr::GlTransaction', as: :source

        has_many :attachments, as: :owner, class_name: 'Lanes::Asset',
                 export: {writable: true}

        has_many :categories, class_name: 'Skr::ExpenseEntryCategory',
                 inverse_of: :entry, export: {writable: true}, foreign_key: 'entry_id'  do
            def total
                proxy_association.loaded? ? inject(0){ | sum, cat | sum+cat.amount } : sum('amount')
            end
        end

        validates :categories, presence: true
        validates :name, presence: true
        validates :occured, presence: true, on: :update

        before_create :set_defaults

        export_sort :amount do |q, dir|
            q.order("category_total #{dir}")
        end

        def self.access_limits_for_query(query, user, params)
            if user.roles.include?('accounting') && (params['id'] || params['review'] == 'true')
                query
            else
                query.where(created_by_id: user.id)
            end
        end

        scope :with_category_details, lambda { | category_id = nil |
            sql = "join skr_expense_entry_details as details on " +
                  "details.expense_entry_id = #{table_name}.#{primary_key}"
            sql << " and #{category_id.to_i} = ANY(category_ids)" if category_id
            q = joins(sql).select("details.*")
            if current_scope.nil? || current_scope.select_values.exclude?("#{table_name}.*")
                q = q.select("#{table_name}.*")
            end
            q
        }, export: true

        def amount
            categories.total
        end

        def approve!(bank, location: Location.default)
            debit = bank.gl_account
            glt = GlTransaction.record(
                location: location, description: "Expenses"
            ) do | transaction |
                transaction.source = self
                categories.each do | entry_category |
                    GlTransaction.push_or_save(
                        owner: self, amount: entry_category.amount,
                        debit: debit, credit: entry_category.category.gl_account
                    )
                end
            end
        end

        private

        def set_defaults
            self.uuid    ||= SecureRandom.uuid
            self.occured ||= Time.now
        end

    end

end
