class Skr.Screens.ExpenseEntry.Approve extends Lanes.React.Component

    modelBindings:
        approvalRequest: ->
            new Skr.Screens.ExpenseEntry.ApprovalRequest

        query: 'props'

    approveSelected: ->
        @approvalRequest.expense_ids = []
        @query.results.eachRow (row, xd) =>
            if LC.Grid.Selections.isSelected(row, xd)
                @approvalRequest.expense_ids.push(@query.results.idForRow(row))
        @approvalRequest.save().then @props.onApproved

    render: ->
        props = _.omit(@props, 'query', 'onApproved')

        <BS.Popover
            {...props}
            id="choose-bank-account" title="Choose bank account">
            <SC.BankAccountFinder
                selectField fieldOnly editOnly
                model={@approvalRequest} name="bank_account"
            />
            <BS.Button
                disabled={not @approvalRequest.isValid()}
                bsStyle="success" onClick={@approveSelected}
            >Approve</BS.Button>
        </BS.Popover>
