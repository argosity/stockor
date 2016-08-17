module Skr

    class ExpenseEntryCategory < Model

        belongs_to :category,
                   class_name: 'Skr::ExpenseCategory', export: {writable: true}

        belongs_to :entry,
                   class_name: 'Skr::ExpenseEntry', export: {writable: true}

        validates :amount, :category, :entry, presence: true

    end

end
