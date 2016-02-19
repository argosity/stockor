class Skr.Screens.TrialBalance extends Skr.Screens.Base

    modelForAccess: 'gl-transaction'
    dataObjects:
        query: ->
            new Lanes.Models.Query
                title: 'Lines', src: Skr.Models.GlAccount
                syncOptions: {with: 'with_trial_balance'}
                fields: [
                    { id:'id', visible: false }
                    { id: 'number', label: 'Acct #', fixedWidth: 120 }
                    'description'
                    {
                        id: 'balance', fixedWidth: 120, textAlign: 'right'
                        format: Lanes.u.format.currency
                    }
                ]

    reload: ->
        @query.results.reload()

    onRowClick: (account) ->
        Lanes.Screens.Definitions.all.get('gl-transactions')
            .display(props: {account: account})

    render: ->
        <LC.ScreenWrapper flexVertical identifier="trial-balance">
            <div className="heading">
                <h3>Trial Balance</h3>
                <span className="explain">Click row to review transactions</span>
                <BS.Button onClick={@reload}>Reload</BS.Button>
            </div>
            <LC.Grid
                onSelectionChange={@onRowClick}
                query={@query}
                ref='grid'
                expandY={true}
            />

        </LC.ScreenWrapper>
