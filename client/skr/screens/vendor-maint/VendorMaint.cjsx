class Skr.Screens.VendorMaint extends Lanes.React.Screen

    dataObjects:
        vendor: ->
            @props.vendor || new Skr.Models.Vendor
        query: ->
            new Lanes.Models.Query({
                syncOptions:
                    include: ['billing_address', 'shipping_address']
                src: Skr.Models.Vendor, fields: [
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
            <Lanes.Screens.CommonComponents
                activity={@state} commands={@state.commands} model={@vendor} />
            <BS.Row>
                <LC.RecordFinder ref="finder" sm=4 autoFocus
                    model={@vendor}
                    commands={@state.commands}
                    query={@query} />
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
