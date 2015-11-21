class Skr.Screens.SalesOrder extends Lanes.React.Screen

    dataObjects:
        sales_order: ->
            @props.sales_order || new Skr.Models.SalesOrder

    syncOptions:
        include: [ 'billing_address', 'shipping_address', 'lines'   ]

    getInitialState: ->
        commands: new Lanes.Screens.Commands(this, modelName: 'sales_order', print: true)

    componentDidMount: ->
        finder = @refs.finder.refs.finder
        finder._setValue(1)
        finder.loadCurrentSelection()
        @state.commands.toggleEdit()

    render: ->
        <LC.ScreenWrapper identifier="sales-order">
            <Lanes.Screens.CommonComponents
                activity={@state} commands={@state.commands} model={@sales_order} />
            <BS.Row>
                <SC.SalesOrderFinder ref='finder' sm=2 editOnly
                    syncOptions={@syncOptions} model={@sales_order}
                    commands={@state.commands} />
                <SC.CustomerFinder selectField sm=2
                    customer={@sales_order.customer} model={@sales_order} />
                <SC.LocationChooser sm=2 label='Src Location'
                    model={@sales_order} />
                <LC.Input sm=6 name='po_num' model={@sales_order} />
            </BS.Row>

            <BS.Row>
               <LC.Input sm=12
                   type='textarea'
                   name="notes"
                   model={@sales_order} />
            </BS.Row>

            <BS.Row>
                <LC.FieldSet sm=12 title="Address" expanded={@sales_order.isNew()}>
                    <SC.Address lg=6 title="Billing"
                        model={@sales_order.billing_address}  />
                    <SC.Address lg=6 title="Shipping"
                        model={@sales_order.shipping_address} />
                </LC.FieldSet>
            </BS.Row>

            <SC.SkuLines
                location={@sales_order.location}
                commands={@state.commands}
                lines={@sales_order.lines} />

            <SC.TotalsLine model={@sales_order} />
        </LC.ScreenWrapper>
