class Skr.Screens.SalesOrder extends Lanes.React.Screen

    dataObjects:
        sales_order: ->
            @props.sales_order || new Skr.Models.SalesOrder

        query: ->
            new Lanes.Models.Query({
                initialFieldIndex: 1
                title: 'Sales Order'
                syncOptions:
                    include: [ 'billing_address', 'shipping_address', 'lines'   ]
                    with:    [ 'with_details', 'customer_code', 'customer_name' ]
                src: Skr.Models.SalesOrder, fields: [
                    { id: 'id', visible: false }
                    { id: 'visible_id' }
                    { id: 'customer_code' }
                    { id: 'notes', flex: 2}
                    { id: 'order_total', title: 'Total' }
                ]
            })

    getInitialState: ->
        isEditing: true
        commands: new Lanes.Screens.Commands(this, modelName: 'sales_order')

    componentDidMount: ->
        @sales_order.visible_id = '1'
        @refs.finder.loadCurrentSelection()

    render: ->
        <div className="sales-order flex-vertically" >
            <Lanes.Screens.CommonComponents
                activity={@state} commands={@state.commands} model={@sales_order} />
            <BS.Row>
                <LC.RecordFinder ref="finder" sm=2 autoFocus
                    model={@sales_order}
                    label='Visible ID'
                    commands={@state.commands}
                    query={@query} />

                <LC.SelectField sm=2
                    label="Customer"
                    name="customer"
                    labelField="code"
                    getSelection={ (so) ->
                        {label: so.customer_code, id: so.customer_id } if so.customer_id and so.customer_code
                    }
                    model={@sales_order} />

                <LC.SelectField sm=2
                    label="Src Location"
                    name="location"
                    labelField="code"
                    model={@sales_order} />
            </BS.Row>

            <BS.Row>
               <LC.Input sm=12
                   type='textarea'
                   name="notes"
                   model={@sales_order} />
            </BS.Row>

            <BS.Row>
                <LC.FieldSet sm=12 title="Address" expanded={@sales_order.isNew()}>
                    <Skr.Components.Address lg=6 title="Billing"
                        model={@sales_order.billing_address}  />
                    <Skr.Components.Address lg=6 title="Shipping"
                        model={@sales_order.shipping_address} />
                </LC.FieldSet>
            </BS.Row>

            <Skr.Components.SkuLines commands={@state.commands} lines={@sales_order.lines} />

            <Skr.Components.OrderTotals model={@sales_order} />
        </div>
