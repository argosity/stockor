class Skr.Screens.Invoice extends Skr.Screens.Base

    modelForAccess: 'invoice'

    syncOptions:
        include: [ 'sales_order', 'billing_address', 'shipping_address', 'lines'   ]

    dataObjects:
        invoice: ->
            @loadOrCreateModel({
                syncOptions: @syncOptions, klass: Skr.Models.Invoice,
                prop: 'invoice', attribute: 'visible_id'
            })

    getInitialState: ->
        commands: new Lanes.Screens.Commands(this, modelName: 'invoice', print: true)

    setSalesOrder: (so) ->
        @invoice.setFromSalesOrder(so)

    render: ->
        <LC.ScreenWrapper identifier="invoice" flexVertical>
            <Lanes.Screens.CommonComponents commands={@state.commands} />
            <BS.Row>
                <SC.InvoiceFinder ref='finder' editOnly sm=3 xs=6
                    model={@invoice} commands={@state.commands}
                    syncOptions={@syncOptions} />

                <SC.SalesOrderFinder autoFocus={false} sm=3 xs=6 editOnly={false}
                    onModelSet={@setSalesOrder} associationName='sales_order'
                    syncOptions={@syncOptions} parentModel={@invoice} />

                <SC.CustomerFinder selectField sm=3 xs=6 model={@invoice} />

                <SC.LocationChooser sm=3 xs=6
                    label='Src Location' model={@invoice} />

                <SC.TermsChooser model={@invoice} sm=3 xs=6 />

                <LC.Input name='po_num' model={@invoice} sm=3 xs=6 />

                <LC.DateTime name='invoice_date'
                    format='ddd, MMM Do YYYY'
                    sm=3 model={@invoice} />

                <SC.PrintFormChooser label="Print Form" sm=3 model={@invoice} />

            </BS.Row>

            <BS.Row>
               <LC.Input sm=12 type='textarea' name="notes" model={@invoice} />
            </BS.Row>

            <BS.Row>
                <LC.FieldSet sm=12 title="Address" expanded={@invoice.isNew()}>
                    <SC.Address lg=6 title="Billing"
                        model={@invoice.billing_address}  />
                    <SC.Address lg=6 title="Shipping"
                        model={@invoice.shipping_address} />
                </LC.FieldSet>
            </BS.Row>

            <SC.SkuLines location={@invoice.location}
                commands={@state.commands} lines={@invoice.lines} />

            <SC.TotalsLine model={@invoice} />
        </LC.ScreenWrapper>
