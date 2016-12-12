##= require_self
##= require ./Payment
##= require ./TotalExtraInfo

class Skr.Screens.Invoice extends Skr.Screens.Base

    syncOptions:
        with: [ 'with_details' ]
        include: [ 'sales_order', 'billing_address', 'shipping_address', 'lines', 'payments' ]

    modelBindings:
        invoice: ->
            @loadOrCreateModel({
                syncOptions: @syncOptions, klass: Skr.Models.Invoice,
                prop: 'invoice', attribute: 'visible_id'
            })

    getInitialState: ->
        commands: new Skr.Screens.Commands(this, modelName: 'invoice', print: true)

    setSalesOrder: (so) -> @invoice.setFromSalesOrder(so)

    showPayment: ->
        Skr.Screens.Invoice.Payment.display(@context.viewport, @invoice)

    PaymentButton: ->
        return null if @invoice.isNew()
        <SC.ToolbarButton onClick={@showPayment}>
            <LC.Icon type="money" />Payment
        </SC.ToolbarButton>

    shouldSaveLinesImmediately: ->
        not @invoice.isNew()

    render: ->
        <LC.ScreenWrapper identifier="invoice" flexVertical>

            <SC.ScreenControls commands={@state.commands}>
                <@PaymentButton />
            </SC.ScreenControls>

            <BS.Row>
                <SC.InvoiceFinder ref='finder' editOnly sm=2 xs=3
                    model={@invoice} commands={@state.commands}
                    syncOptions={@syncOptions} />

                <SC.SalesOrderFinder autoFocus={false} sm=2 xs=3 editOnly={false}
                    onModelSet={@setSalesOrder} associationName='sales_order'
                    syncOptions={ include: ['customer', 'billing_address', 'shipping_address' ] }
                    parentModel={@invoice} />

                <SC.CustomerFinder
                    fallBackValue={@invoice.customer_code}
                    syncOptions={ include: ['billing_address', 'shipping_address' ] }
                    selectField sm=3 xs=6 model={@invoice} />

                <SC.TermsChooser model={@invoice} sm=3 xs=6 />

                <LC.DisplayValue sm=2 xs=4 label='State'
                    name='state_name' model={@invoice} />
            </BS.Row>
            <BS.Row>
                <LC.Input name='po_num' model={@invoice} sm=3 xs=6 />

                <LC.DateTime name='invoice_date' format='ddd, MMM Do YYYY'
                    sm=3 model={@invoice} />

                <SC.PrintFormChooser label="Print Form" sm=3 xs=4 model={@invoice} />

                <SC.LocationChooser sm=3 xs=4
                    label='Src Location' model={@invoice} />
            </BS.Row>

            <BS.Row>
               <LC.TextArea name="notes" model={@invoice} xs=12 />
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
                queryBuilder={@linesQueryBuilder}
                saveImmediately={@shouldSaveLinesImmediately}
                commands={@state.commands} lines={@invoice.lines} />

            <SC.TotalsLine model={@invoice} extraInfo={
                <Skr.Screens.Invoice.TotalExtraInfo invoice={@invoice} />
            } />
        </LC.ScreenWrapper>
