class Skr.Screens.CustomerMaint extends Lanes.React.Screen

    dataObjects:
        customer: ->
            @props.customer || new Skr.Models.Customer

    getInitialState: ->
        commands: new Lanes.Screens.Commands(this, modelName: 'customer')

    modelForAccess: 'customer'

    render: ->
        <div className="customer-maint">
            <Lanes.Screens.CommonComponents
                activity={@state} commands={@state.commands} model={@customer} />
            <BS.Row>
                <Skr.Components.CustomerFinder sm=4 editOnly
                    commands={@state.commands} customer={@customer} />
                <LC.Input sm=8 name="name" model={@customer} />
            </BS.Row>
            <BS.Row>
                <LC.Input sm=12
                    type='textarea'
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
