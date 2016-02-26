class Skr.Screens.SalesOrder extends Lanes.React.Screen

    syncOptions:
        include: [ 'billing_address', 'shipping_address', 'lines' ]

    dataObjects:
        sales_order: ->
            @loadOrCreateModel({
                syncOptions: @syncOptions, klass: Skr.Models.SalesOrder
                prop: 'sales_order', attribute: 'visible_id'
            })

    getInitialState: ->
        commands: new Skr.Screens.Commands(this, modelName: 'sales_order', print: true)

    render: ->
        <LC.ScreenWrapper identifier="sales-order" flexVertical>
            <SC.ScreenControls commands={@state.commands} />
            <BS.Row>

                <SC.SalesOrderFinder ref='finder' sm=4 xs=6 editOnly
                    syncOptions={@syncOptions} model={@sales_order}
                    commands={@state.commands} />

                <SC.CustomerFinder selectField    sm=4 xs=6
                    customer={@sales_order.customer} model={@sales_order} />

                <LC.Input sm=3 name='po_num' model={@sales_order} sm=4 xs=6 />

            </BS.Row>

            <BS.Row>

                <SC.TermsChooser model={@sales_order} sm=3 xs=6 />

                <SC.LocationChooser label='Src Location' sm=3 xs=6
                    model={@sales_order} />


                 <LC.DateTime name='order_date' format='ddd, MMM Do YYYY' sm=3 xs=6
                    model={@sales_order} />

                <SC.PrintFormChooser label="Print Form" sm=3 model={@sales_order} sm=3 xs=6 />
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
