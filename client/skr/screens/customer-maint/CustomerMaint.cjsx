class Skr.Screens.CustomerMaint extends Lanes.React.Screen

    dataObjects:
        customer: ->
            @props.customer || new Skr.Models.Customer

    getInitialState: ->
        commands: new Lanes.Screens.Commands(this, modelName: 'customer')

    modelForAccess: 'customer'

    setForm: (val, {type}) ->
        @customer.forms = _.extend({}, @customer.forms, {"#{type}": val})

    render: ->
        <LC.ScreenWrapper identifier="customer-maint">
            <Lanes.Screens.CommonComponents commands={@state.commands} />
            <BS.Row>
                <SC.CustomerFinder sm=4 editOnly ref="finder"
                    syncOptions={include: ['billing_address', 'shipping_address']}
                    commands={@state.commands} model={@customer} name='code' />
                <LC.Input sm=8 name="name" model={@customer} />
            </BS.Row>
            <BS.Row>
                <LC.Input sm=12
                    type='textarea'
                    name="notes"
                    model={@customer} />
            </BS.Row>
            <BS.Row>
                <SC.GlAccountChooser sm=3 model={@customer}
                    label="Receivables Account" name="gl_receivables_account"/>
                <SC.TermsChooser model={@customer} sm=3 />
                <SC.PrintFormChooser
                    label="Sales Order Form" sm=3 model={@customer}
                    onChange={@setForm} type="sales_order"
                    value={@customer.forms?.sales_order}
                    choices={Skr.Models.SalesOrder.Templates} />
                <SC.PrintFormChooser
                    label="Invoice Form" sm=3 model={@customer}
                    onChange={@setForm} type="invoice"
                    value={@customer.forms?.invoice}
                    choices={Skr.Models.Invoice.Templates} />
            </BS.Row>
            <BS.Row>
                <LC.FieldSet sm=12 title="Address">
                    <SC.Address lg=6 title="Billing"
                        model={@customer.billing_address}  />
                    <SC.Address lg=6 title="Shipping"
                        model={@customer.shipping_address} />
                </LC.FieldSet>
            </BS.Row>
        </LC.ScreenWrapper>
