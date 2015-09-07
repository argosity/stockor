class Skr.Screens.SalesOrder extends Lanes.React.Screen

    dataObjects:
        sales_order: ->
            @props.sales_order || new Skr.Models.SalesOrder

        query: ->
            new Lanes.Models.Query({
                initialFieldIndex: 1
                title: 'Sales Order'
                syncOptions:
                    include: ['billing_address', 'shipping_address', 'lines']
                    with: ['with_details', 'customer_code', 'customer_name']
                src: Skr.Models.SalesOrder, fields: [
                    { id: 'id', visible: false}
                    { id: 'visible_id' }
                    { id: 'customer_code' }
                    { id: 'notes', flex: 2}
                    { id: 'order_total', title: 'Total' }
                ]
            })
        linesQuery: ->
            new Lanes.Models.Query({
                src: Skr.Models.SoLine, fields: [
                    { id:'id', visible: false}
                    { id: 'sku_code' }
                    { id: 'description', flex: 2}
                    { id: 'uom', title: 'UOM', query: false, format: (v, r, q) -> v.combined }
                    { id: 'qty',   textAlign: 'center' }
                    { id: 'price', textAlign: 'right'  }
                ]
            })

    getInitialState: ->
        isEditing: true
        commands: new Lanes.Screens.Commands(this,
            modelName: 'sales_order'
            modelDidRebind: (model) => @linesQuery.src = @sales_order.lines
        )

    componentDidMount: ->
        @sales_order.visible_id = '1'
        @refs.finder.loadCurrentSelection()

    editors: (props) ->
        sku_code: ({model}) ->
            <LC.SelectField
                key="sku-code"
                editOnly writable unstyled
                model={model}
                syncOptions={include: 'sku', fields: 'sku_code'}
                labelField="sku_code"
                name="sku_loc"
            />
        uom: ({model}) ->
            return '' unless model.sku_loc_id
            <LC.SelectField
                key="uom"
                editOnly writable unstyled
                model={model}
                queryOrder={size: 'desc'}
                labelField="combined"
                name="uom"
                collection={model.uom_choices}
            />

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

            <LC.Grid query={@linesQuery}
                commands={@state.commands}
                autoLoadQuery={false}
                expandY={true}
                columEditors={@editors()}
                editorProps: {syncImmediatly: false}
                height=200
                allowDelete={true}
                allowCreate={true}
                editor={true}
            />
            <BS.Row>
                <BS.Col md=10 className="text-right">
                    Total:
                </BS.Col>
                <BS.Col md=2>
                    <Skr.Components.Currency amount={@sales_order.total} />
                </BS.Col>
            </BS.Row>
        </div>
