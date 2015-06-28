class Skr.Screens.CustomerMaint extends Lanes.React.Screen

    dataObjects:
        customer: ->
            @props.customer || new Skr.Models.Customer
        query: ->
            new Lanes.Models.Query({
                loadAssociations: ['billing_address', 'shipping_address']
                modelClass: Skr.Models.Customer, fields: [
                    {id:'id', visible: false}
                    'code', 'name', 'notes',
                    { id: 'open_balance', flex: 0.5, textAlign: 'center' }
                ]
            })

    getInitialState: ->
        commands: new Lanes.Screens.Commands(this, modelName: 'customer')

    modelForAccess: 'customer'

    componentDidMount: ->
        _.defer =>
            @getDOMNode().querySelector('input[name=code]').value = "STOCKOR"
            @refs.finder.loadCurrentSelection()

    render: ->
        <div className="customer-maint">
            <LC.Toolbar commands={@state.commands} />
            <LC.ErrorDisplay model={@customer} />
            <BS.Row>
                <LC.RecordFinder ref="finder" sm=4 autoFocus
                    model={@customer}
                    commands={@state.commands}
                    query={@query} />
                <LC.TextField sm=8 name="name" model={@customer} />
            </BS.Row>
            <BS.Row>
               <LC.TextArea sm=12
                   name="notes"
                   model={@customer} />
            </BS.Row>
            <BS.Row>
                <LC.SelectField sm=6
                    label="Receivables Account"
                    name="gl_receivables_account"
                    labelField="combined_name"
                    model={@customer} />
                <LC.SelectField sm=6
                    label="Payment Terms"
                    name="terms"
                    labelField="code"
                    model={@customer} />
            </BS.Row>
            <BS.Row>
                <LC.FieldSet sm=12 title="Address">
                    <Skr.Components.Address lg=6 title="Billing"
                        model={@customer.billing_address}  />
                    <Skr.Components.Address lg=6 title="Shipping"
                        model={@customer.shipping_address} />
                </LC.FieldSet>
            </BS.Row>

        </div>
