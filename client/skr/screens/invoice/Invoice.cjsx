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

    setSalesOrder: (so) ->
        @invoice.setFromSalesOrder(so)

    render: ->
        <div className="invoice flex-vertically" >
            <Lanes.Screens.CommonComponents
                activity={@state} commands={@state.commands} model={@invoice} />
            <BS.Row>
                <LC.RecordFinder ref="finder" sm=2 autoFocus
                    model={@invoice}
                    label='Visible ID'
                    commands={@state.commands}
                    query={@query} />

                <Skr.Components.SalesOrderFinder
                    model={@invoice.sales_order}
                    onModelSet={@setSalesOrder}/>

                <LC.SelectField sm=2
                    label="Customer"
                    name="customer"
                    labelField="code"
                    getSelection={ (so) ->
                        {label: so.customer_code, id: so.customer_id } if so.customer_id and so.customer_code
                    }
                    model={@invoice} />

                <LC.SelectField sm=2
                    label="Src Location"
                    name="location"
                    labelField="code"
                    model={@invoice} />
            </BS.Row>

            <BS.Row>
               <LC.Input sm=12
                   type='textarea'
                   name="notes"
                   model={@invoice} />
            </BS.Row>

            <BS.Row>
                <LC.FieldSet sm=12 title="Address" expanded={@invoice.isNew()}>
                    <Skr.Components.Address lg=6 title="Billing"
                        model={@invoice.billing_address}  />
                    <Skr.Components.Address lg=6 title="Shipping"
                        model={@invoice.shipping_address} />
                </LC.FieldSet>
            </BS.Row>

            <Skr.Components.SkuLines commands={@state.commands} lines={@invoice.lines} />

            <Skr.Components.OrderTotals model={@invoice} />
        </div>
