class Skr.Components.SystemSettings extends Lanes.React.Component

    propTypes:
        settings: React.PropTypes.object.isRequired

    modelBindings:
        banks: ->
            Skr.Models.BankAccount.Collection.fetch()
        sequentialIds: ->
            new Skr.Models.SequentialId
        ccgateway: ->
            Skr.Models.CreditCardGateway.fetchById()

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
        onChange = (num) => @sequentialIds.updateValue(id, num)
        <BS.Row>
            <BS.Col sm=8>{name}</BS.Col>
            <BS.Col sm=4>
                <Lanes.Vendor.ReactWidgets.NumberPicker value={count} onChange={onChange} />
            </BS.Col>
        </BS.Row>

    onSave: ->
        @sequentialIds.save() if @sequentialIds.isDirty
        @ccgateway.save()


    setGatewayType: (type) ->
        @ccgateway.type = type.id

    renderCreditCardGateway: ->

        <BS.Col sm=4>

            <LC.FormGroup sm=12 label="Credit Card Gateway">
                <Lanes.Vendor.ReactWidgets.DropdownList
                    ref="ccgateway"
                    data={Skr.Models.CreditCardGateway.allTypes()}
                    valueField='id' textField='name'
                    value={@ccgateway.type}
                    onChange={@setGatewayType}
                />
            </LC.FormGroup>
            <LC.Input sm=12 name='login' model={@ccgateway} />
            <LC.Input sm=12 type='password' name='password' model={@ccgateway} />
        </BS.Col>



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

                <LC.FormGroup sm=4 label="Auto Assigned next ID">
                    {for si in @sequentialIds.ids
                        <@SequentialId si={si} key={si.id} />}
                </LC.FormGroup>

                {@renderCreditCardGateway()}

            </BS.Row>
            <BS.Row>
                <BS.Col sm=6>
                    <SC.LatexSnippets settings={@props.settings} />
                </BS.Col>
            </BS.Row>

        </div>
