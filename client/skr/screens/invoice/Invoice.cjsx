##= require_self
##= require ./Payment

class Skr.Screens.Invoice extends Skr.Screens.Base

    modelForAccess: 'invoice'

    syncOptions:
        with: [ 'with_details' ]
        include: [ 'sales_order', 'billing_address', 'shipping_address', 'lines'   ]

    dataObjects:
        invoice: ->
            @loadOrCreateModel({
                syncOptions: @syncOptions, klass: Skr.Models.Invoice,
                prop: 'invoice', attribute: 'visible_id'
            })

    getInitialState: ->
        isEditing: true
        commands: new Skr.Screens.Commands(this, modelName: 'invoice', print: true)

    setSalesOrder: (so) -> @invoice.setFromSalesOrder(so)
    onPayment: -> @invoice.save()

    getPayment: ->
        @context.viewport.displayModal
            title: "Accept Payment", autoHide: true, size: 'sm', onOk: @onPayment,
            body: =>
                <Skr.Screens.Invoice.Payment invoice={@invoice} />

    PaymentButton: ->
        return null if @invoice.isNew() or @invoice.isPaidInFull()
        <SC.ToolbarButton onClick={@getPayment}>
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
                    syncOptions={@syncOptions} parentModel={@invoice} />

                <SC.CustomerFinder
                    defaultLabel={@invoice.customer_code}
                    selectField sm=3 xs=6 model={@invoice} />

                <SC.TermsChooser model={@invoice} sm=3 xs=6 />

                <LC.DisplayValue sm=2 xs=4
                    name='state' model={@invoice} />
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
                saveImmediately={@shouldSaveLinesImmediately}
                commands={@state.commands} lines={@invoice.lines} />

            <SC.TotalsLine model={@invoice} />
        </LC.ScreenWrapper>
