class Skr.Screens.Payments extends Skr.Screens.Base

    syncOptions:
        include: [ 'address', 'bank_account', 'category', 'vendor' ]

    dataObjects:
        payment: ->
            @loadOrCreateModel({
                syncOptions: @syncOptions
                klass: Skr.Models.Payment
                prop: 'payment', attribute: 'visible_id'
            })

        query: ->
            new Lanes.Models.Query({
                syncOptions: @syncOptions
                src: Skr.Models.Payment, fields: [
                    {id:'id',   visible: false}
                    {id:'visible_id', label: 'Payment ID', fixedWidth: 130 },
                    {id:'name', flex: 1}
                    {
                        id:'amount',  fixedWidth: 120, textAlign: 'right',
                        format: Lanes.u.format.currency
                    }
                ]
            })

    getInitialState: ->
        commands: new Skr.Screens.Commands(this, modelName: 'payment')

    render: ->
        <LC.ScreenWrapper identifier="payments">
            <SC.ScreenControls commands={@state.commands} />
            <BS.Row>
                <LC.RecordFinder ref="finder" sm=3 autoFocus editOnly
                    commands={@state.commands} model={@category}
                    label='Payment ID' name='visible_id' model={@payment} query={@query}
                />
                <SC.BankAccountFinder smOffset=1 selectField name='bank_account'
                    model={@payment} />
                <SC.PaymentCategoryFinder selectField name='category' labelField='code'
                    model={@payment} />
                <LC.DateTime smOffset=1 name='date' format='ddd, MMM Do YYYY'
                    sm=3 model={@payment} />
            </BS.Row>
            <BS.Row>
                <SC.VendorFinder sm=2 selectField
                    syncOptions={include:['billing_address']} model={@payment} />
                <LC.Input sm=6 name="name" model={@payment} />
                <LC.NumberInput smOffset=1 sm=3 name="amount" align='right' model={@payment} />
            </BS.Row>
            <BS.Row>
                <LC.Input type='textarea' smOffset=2 sm=6 name="address" model={@payment} />
            </BS.Row>
            <BS.Row>
               <LC.Input sm=12 name="notes" model={@payment} />
            </BS.Row>

        </LC.ScreenWrapper>
