class Skr.Screens.VendorMaint extends Lanes.React.Screen

    dataObjects:
        vendor: ->
            @props.vendor || new Skr.Models.Vendor

    getInitialState: ->
        commands: new Lanes.Screens.Commands(this, modelName: 'vendor')

    modelForAccess: 'vendor'

    render: ->
        <LC.ScreenWrapper identifier="vendor-maint">
            <Lanes.Screens.CommonComponents commands={@state.commands} />
            <BS.Row>
                <SC.VendorFinder sm=4 editOnly
                    commands={@state.commands} model={@vendor} />
                <LC.Input sm=8 name="name" model={@vendor} />
            </BS.Row>
            <BS.Row>
               <LC.Input sm=12 type='textarea' name="notes" model={@vendor} />
            </BS.Row>
            <BS.Row>
                <SC.GlAccountChooser sm=4 label="Payables Account"
                    name="gl_payables_account" model={@vendor} />
                <SC.GlAccountChooser sm=4 label="Freight Account"
                    name="gl_freight_account" model={@vendor} />
                <SC.TermsChooser sm=4 model={@vendor} />
            </BS.Row>
            <BS.Row>
                <LC.FieldSet sm=12 title="Address">
                    <SC.Address lg=6 title="Billing"  model={@vendor.billing_address}  />
                    <SC.Address lg=6 title="Shipping" model={@vendor.shipping_address} />
                </LC.FieldSet>
            </BS.Row>

        </LC.ScreenWrapper>
