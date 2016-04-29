class Skr.Screens.VendorMaint extends Lanes.React.Screen

    syncOptions:
        include: ['billing_address', 'shipping_address']

    dataObjects:
        vendor: ->
            @loadOrCreateModel({
                syncOptions: @syncOptions, klass: Skr.Models.Vendor,
                prop: 'vendor', attribute: 'code'
            })

    getInitialState: ->
        commands: new Skr.Screens.Commands(this, modelName: 'vendor')

    modelForAccess: 'vendor'

    render: ->
        <LC.ScreenWrapper identifier="vendor-maint">
            <SC.ScreenControls commands={@state.commands} />
            <BS.Row>
                <SC.VendorFinder model={@vendor} sm=4 editOnly autofocus
                    syncOptions={@syncOptions}
                    model={@vendor} name='code'
                    commands={@state.commands}  />
                <LC.Input sm=8 name="name" model={@vendor} />
            </BS.Row>
            <BS.Row>
               <LC.TextArea sm=12 name="notes" model={@vendor} />
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
