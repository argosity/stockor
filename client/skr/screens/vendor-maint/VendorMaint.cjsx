class Skr.Screens.VendorMaint extends Lanes.React.Screen

    dataObjects:
        vendor: ->
            @props.vendor || new Skr.Models.Vendor

    getInitialState: ->
        commands: new Lanes.Screens.Commands(this, modelName: 'vendor')

    modelForAccess: 'vendor'

    render: ->
        <div className="vendor-maint">
            <Lanes.Screens.CommonComponents
                activity={@state} commands={@state.commands} model={@vendor} />
            <BS.Row>
                <Skr.Components.VendorFinder sm=4 editOnly
                    commands={@state.commands} vendor={@vendor} />

                <LC.Input sm=8 name="name" model={@vendor} />
            </BS.Row>
            <BS.Row>
               <LC.Input sm=12
                   type='textarea'
                   name="notes"
                   model={@vendor} />
            </BS.Row>
            <BS.Row>
                <LC.SelectField sm=4
                    label="Payables Account"
                    name="gl_payables_account"
                    labelField="combined_name"
                    model={@vendor} />
                <LC.SelectField sm=4
                    label="Freight Account"
                    name="gl_freight_account"
                    labelField="combined_name"
                    model={@vendor} />
                <LC.SelectField sm=4
                    label="Payment Terms"
                    name="terms"
                    labelField="code"
                    model={@vendor} />
            </BS.Row>
            <BS.Row>
                <LC.FieldSet sm=12 title="Address">
                    <Skr.Components.Address lg=6 title="Billing"
                        model={@vendor.billing_address}  />
                    <Skr.Components.Address lg=6 title="Shipping"
                        model={@vendor.shipping_address} />
                </LC.FieldSet>
            </BS.Row>

        </div>
