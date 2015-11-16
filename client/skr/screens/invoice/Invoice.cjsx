class Skr.Screens.Invoice extends Skr.Screens.Base

    dataObjects:
        invoice: ->
            @props.invoice || new Skr.Models.Invoice

        query: ->
            new Lanes.Models.Query({
                initialFieldIndex: 1
                title: 'Invoice'
                syncOptions:
                    include: [ 'sales_order', 'billing_address', 'shipping_address', 'lines' ]
                    with:    [ 'with_details', 'customer_code', 'customer_name' ]
                src: Skr.Models.Invoice, fields: [
                    { id: 'id', visible: false }
                    { id: 'visible_id' }
                    { id: 'customer_code' }
                    { id: 'notes', flex: 2}
                    { id: 'invoice_total', title: 'Total' }
                ]
            })

    getInitialState: ->
        commands: new Lanes.Screens.Commands(this, modelName: 'invoice', print: true)

    componentDidMount: ->
        @refs.finder._setValue(1)
        @refs.finder.loadCurrentSelection()
        @state.commands.toggleEdit()

    setSalesOrder: (so) ->
        @invoice.setFromSalesOrder(so)

    render: ->
        <div className="invoice flex-vertically">
            <Lanes.Screens.CommonComponents
                activity={@state} commands={@state.commands} model={@invoice} />

            <BS.Row>
                <LC.RecordFinder ref="finder" sm=2 autoFocus editOnly
                    model={@invoice}
                    name='visible_id'
                    label='Visible ID'
                    commands={@state.commands}
                    query={@query} />
                <SC.CustomerFinder sm=2 selectField
                    model={@invoice} customer={@invoice.customer} />
                <SC.LocationChooser sm=2 label='Src Location' model={@invoice} />
                <LC.Input sm=2 name='po_num' model={@sales_order} />
            </BS.Row>

            <BS.Row>
               <LC.Input sm=12
                   type='textarea'
                   name="notes"
                   model={@invoice} />
            </BS.Row>

            <BS.Row>
                <LC.FieldSet sm=12 title="Address" expanded={@invoice.isNew()}>
                    <SC.Address lg=6 title="Billing"
                        model={@invoice.billing_address}  />
                    <SC.Address lg=6 title="Shipping"
                        model={@invoice.shipping_address} />
                </LC.FieldSet>
            </BS.Row>

            <SC.SkuLines commands={@state.commands} lines={@invoice.lines} />

            <SC.TotalsLine model={@invoice} />
        </div>
