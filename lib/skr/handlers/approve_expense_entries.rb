module Skr
    module Handlers
        class ApproveExpenseEntries < ::Lanes::API::ControllerBase

            def create
                bank_account = BankAccount.find(data['bank_account_id'])
                entries = []
                ExpenseEntry.where(id: data['expense_ids']).includes(:gl_transaction).find_each do | entry |
                    entries.push entry.approve!(bank_account) unless entry.gl_transaction
                end
                std_api_reply :create, { entries: entries }, success: true
            end

        end
    end
end
