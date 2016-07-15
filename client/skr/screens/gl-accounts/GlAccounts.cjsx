class Skr.Screens.GlAccounts extends Skr.Screens.Base

    modelBindings:
        account: ->
            @loadOrCreateModel({
                klass: Skr.Models.GlAccount,
                prop: 'account', attribute: 'number'
            })

    getInitialState: ->
        commands: new Skr.Screens.Commands(this, modelName: 'account', print: true)

    render: ->
        <LC.ScreenWrapper identifier="gl-accounts">
            <SC.ScreenControls commands={@state.commands} />
            <BS.Row>

                <SC.GlAccountChooser sm=2 model={@account}
                    commands={@state.commands}
                    label='Number' name="number" editOnly finderField />

                <LC.ToggleField sm=2 align='center' label="Active?"
                    name="is_active" model={@account} />

                <LC.Input sm=8 name="name" model={@account} />

            </BS.Row>
            <BS.Row>
                <LC.TextArea sm=12 name="description" model={@account} />
            </BS.Row>
        </LC.ScreenWrapper>
