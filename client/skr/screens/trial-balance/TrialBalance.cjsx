class Accounts extends Skr.Models.Base

    associations:
        account: { model: "GlAccount" }


class Skr.Screens.TrialBalance extends Skr.Screens.Base

    modelForAccess: 'gl-transaction'
    dataObjects:
        accounts: -> new Accounts
        query: ->
            @query = new Lanes.Models.Query
                title: 'Lines', src: Skr.Models.GlAccount,
                fields: [
                    { id:'id', visible: false}
                    { id: 'sku_code' }
                ]

    render: ->
        <LC.ScreenWrapper identifier="trial-balance">
            <h3>Trial Balance</h3>
            <SC.GlAccountChooser model={@accounts} name='account' editOnly sm={4} />
        </LC.ScreenWrapper>
