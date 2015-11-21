class Skr.Screens.Invoice extends Skr.Screens.Base

    dataObjects:
        invoice: ->
            @props.invoice || new Skr.Models.Invoice

    modelForAccess: 'invoice'

    syncOptions:
        include: [ 'sales_order', 'billing_address', 'shipping_address', 'lines'   ]

    getInitialState: ->
        commands: new Lanes.Screens.Commands(this, modelName: 'invoice', print: true)

    componentDidMount: ->
        finder = @refs.finder.refs.finder
        finder._setValue(1)
        finder.loadCurrentSelection()
        @state.commands.toggleEdit()

    setSalesOrder: (so) ->
        @invoice.setFromSalesOrder(so)

    render: ->
        <LC.ScreenWrapper identifier="invoice">
            <Lanes.Screens.CommonComponents
                activity={@state} commands={@state.commands} model={@invoice} />

            <BS.Row>
                <SC.InvoiceFinder ref='finder' editOnly md=2 sm=3 xs=6
                    model={@invoice} commands={@state.commands}
                    syncOptions={@syncOptions} />

                <SC.SalesOrderFinder editOnly autoFocus={false} md=2 sm=3 xs=6
                    onModelSet={@setSalesOrder} associationName='sales_order'
                    syncOptions={@syncOptions} parentModel={@invoice} />

                <SC.CustomerFinder selectField md=2 sm=3 xs=6
                    model={@invoice} />

                <SC.LocationChooser md=2 sm=3 xs=6
                    label='Src Location' model={@invoice} />

                <SC.TermsChooser model={@invoice} md=2 smd=3 xs=6 />

                <LC.Input name='po_num' model={@invoice} md=2 sm=9 />
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
