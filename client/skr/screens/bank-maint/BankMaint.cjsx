class Skr.Screens.BankMaint extends Skr.Screens.Base
    syncOptions:
        include: [ 'address' ]

    modelBindings:
        bank: ->
            @loadOrCreateModel({
                syncOptions: @syncOptions, klass: Skr.Models.BankAccount
                prop: 'bank', attribute: 'code'
            })

    getInitialState: ->
        commands: new Skr.Screens.Commands(this, modelName: 'bank', print: true)

    render: ->
        <LC.ScreenWrapper identifier="bank-maint">
            <SC.ScreenControls commands={@state.commands} />

            <BS.Row>
                <SC.BankAccountFinder ref='finder' label='Code' sm=3 xs=4 editOnly
                    syncOptions={@syncOptions} model={@bank}
                    commands={@state.commands} />

                <LC.Input sm=6 name="name" model={@bank} />

                <SC.GlAccountChooser sm=3 label="GL Account"
                    name="gl_account" model={@bank} />
            </BS.Row>
            <BS.Row>
                <LC.Input sm=12 name="description" model={@bank} />
            </BS.Row>

            <SC.Address lg=6 title="Address for Check Printing"
                model={@bank.address}  />

            <LC.FieldSet sm=12 title="Account Information *">
                <p>* Can be ommited if pre-printed checks are used</p>
                <BS.Row>
                    <LC.Input sm=6 name="routing_number" model={@bank} />
                    <LC.Input sm=6 name="account_number" model={@bank} />
                </BS.Row>
            </LC.FieldSet>
        </LC.ScreenWrapper>
