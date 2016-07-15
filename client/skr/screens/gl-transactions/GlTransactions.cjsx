RenderPosting = (props) ->
    contents = _.map props.value, (posting, i) ->
        <span className='posting' key={i}>
            {posting.account_number}
            <SC.Currency amount={posting.amount} />
        </span>
    <div>{contents}</div>

class Transactions extends Skr.Models.Base

    query: new Lanes.Models.Query
        title: 'Lines', src: Skr.Models.GlTransaction
        syncOptions: { with: ['with_details'] }
        fields: [
            { id: 'id', visible: false }
            { id: 'created_at', title: 'Date', format: Lanes.u.format.shortDate, fixedWidth: 100 }
            { id: 'debit_details',  title: 'Debit',  component: RenderPosting }
            { id: 'credit_details', title: 'Credit', component: RenderPosting }
            { id: 'source_type', fixedWidth: 180  }
            { id: 'description' }
        ]

    associations:
        account: { model: "GlAccount" }

    events:
        'change:account': 'onAccountChange'

    onAccountChange: (account) ->
        acct_num = if @account?.number then "#{@account.number}%" else ''
        @query.syncOptions = { with: { with_details: acct_num } }
        @query.results.reload()

class Skr.Screens.GlTransactions extends Skr.Screens.Base

    modelForAccess: 'gl-transaction'

    modelBindings:
        transactions: -> new Transactions(account: @props.account)

    render: ->
        <LC.ScreenWrapper flexVertical identifier="gl-transactions">
            <h3>GL Transactions</h3>
            <SC.GlAccountChooser model={@transactions} name='account' editOnly sm={4} />
            <LC.Grid query={@transactions.query} />
        </LC.ScreenWrapper>
