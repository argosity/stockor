module Skr

    class ExpenseCategory < Model

        belongs_to :gl_account, class_name: 'Skr::GlAccount', export: true

        validates :name, :gl_account, presence: true

        has_many :entry_categories, foreign_key: 'category_id',
                 class_name: 'Skr::ExpenseEntryCategory' do

            def total
                proxy_association.loaded? ? inject(0){ | sum, cat | sum+cat.amount } : sum('amount')
            end

        end

        has_many :entries,  class_name: 'Skr::ExpenseEntry',
                 through: :entry_categories, source: :entry

        def balance
            entry_categories.total
        end

    end

end
