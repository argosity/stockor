class Skr.Components.SystemSettings extends Lanes.React.Component

    dataObjects:
        banks: ->
            Skr.Models.BankAccount.Collection.fetch()
        sequentialIds: ->
            new Skr.Models.SequentialId

    componentWillMount: ->
        @sequentialIds.fetch()

    setBankAccount: (value) ->
        Lanes.config.system_settings
            .setValueForExtension('skr', 'bank_account_id', value.id)
        @forceUpdate()

    getBankAccount: ->
        id = Lanes.config.system_settings.forExtension('skr').bank_account_id
        if id then {id} else undefined

    SequentialId: ({si}) ->
        {id, name, count} = si
        onChange = (ev) => @sequentialIds.updateValue(id, ev.target.value)
        <BS.Row>
            <BS.Col sm=8>{name}</BS.Col>
            <BS.Col sm=4>
                <input type="number" value={count} onChange={onChange} />
            </BS.Col>
        </BS.Row>

    onSave: ->
        @sequentialIds.save() if @sequentialIds.isDirty

    render: ->
        <div className="skr-system-settings">
            <BS.Row>
                <BS.Col sm=3>
                    <SC.BankAccountFinder selectField sm=12
                        label="Default Bank Account"
                        model={Lanes.config.system_settings}
                        choices={this.banks.models}
                        setSelection={@setBankAccount}
                        getSelection={@getBankAccount}
                    />
                </BS.Col>
                <BS.Col sm=4>
                    <h4>Auto Assigned next ID</h4>
                    {for si in @sequentialIds.ids
                        <@SequentialId si={si} key={si.id} />}
                </BS.Col>

            </BS.Row>

        </div>
