class Skr.Screens.VendorMaint extends Lanes.React.Screen

    dataObjects:
        vendor: ->
            @props.vendor || new Skr.Models.Vendor
        query: ->
            new Lanes.Models.Query({
                loadAssociations: ['billing_address', 'shipping_address']
                modelClass: Skr.Models.Vendor, fields: [
                    {id:'id', visible: false}
                    'code', 'name',
                    { id: 'notes', flex: 2}

                ]
            })

    getInitialState: ->
        commands: new Lanes.Screens.Commands(this, modelName: 'vendor')

    modelForAccess: 'vendor'

    render: ->
        <div className="vendor-maint">
            <LC.Toolbar commands={@state.commands} />
            <LC.ErrorDisplay model={@vendor} />
            <BS.Row>
                <LC.RecordFinder ref="finder" sm=4 autoFocus
                    model={@vendor}
                    commands={@state.commands}
                    query={@query} />
                <LC.TextField sm=8 name="name" model={@vendor} />
            </BS.Row>
            <BS.Row>
               <LC.TextArea sm=12
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
