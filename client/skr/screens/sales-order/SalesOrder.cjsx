class Skr.Screens.SalesOrder extends Lanes.React.Screen

    dataObjects:
        sales_order: ->
            @props.sales_order || new Skr.Models.SalesOrder

        query: ->
            new Lanes.Models.Query({
                loadAssociations: ['billing_address', 'shipping_address']
                modelClass: Skr.Models.SalesOrder, fields: [
                    {id:'id', visible: false}
                    'visible_id', 'customer_code',
                    'total'
                    { id: 'notes', flex: 2}

                ]
            })

    getInitialState: ->
        commands: new Lanes.Screens.Commands(this, modelName: 'sales_order')

    render: ->
        <div className="sales-order">
            <LC.Toolbar commands={@state.commands} />
            <LC.ErrorDisplay model={@sales_order} />
            <BS.Row>
                <LC.RecordFinder ref="finder" sm=4 autoFocus
                    model={@sales_order}
                    commands={@state.commands}
                    query={@query} />
                <LC.TextField sm=8 name="name" model={@sales_order} />
            </BS.Row>
            <BS.Row>
               <LC.TextArea sm=12
                   name="notes"
                   model={@sales_order} />
            </BS.Row>

        </div>
