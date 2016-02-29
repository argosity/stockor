class Skr.Components.SystemSettings extends Lanes.React.Component

    dataObjects:
        banks: ->
            Skr.Models.BankAccount.Collection.fetch()

    setBankAccount: (value) ->
        Lanes.config.system_settings
            .setValueForExtension('skr', 'bank_account_id', value.id)
        @forceUpdate()

    getBankAccount: ->
        id = Lanes.config.system_settings.forExtension('skr').bank_account_id
        if id then {id} else undefined

    render: ->
        <BS.Row className="skr-system-settings">

            <SC.BankAccountFinder selectField
                sm=3 label="Default Bank Account"
                choices={this.banks.models}
                setSelection={@setBankAccount}
                getSelection={@getBankAccount}
            />

        </BS.Row>
