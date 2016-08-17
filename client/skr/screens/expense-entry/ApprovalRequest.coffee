class Skr.Screens.ExpenseEntry.ApprovalRequest extends Lanes.Models.Base

    props:
        bank_account_id:{"type":"integer"}
        expense_ids: { type: 'array', default: -> [] }

    api_path: ->
        '/skr/expense-entries/approve'

    associations:
        bank_account: { model: "BankAccount" }


    isValid: -> !!@bank_account_id
