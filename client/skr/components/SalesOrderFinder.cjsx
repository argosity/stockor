class Skr.Components.SalesOrderFinder extends Lanes.React.Component

    propTypes:
        onModelSet: React.PropTypes.func
        commands:   React.PropTypes.object
        autoFocus:  React.PropTypes.bool

    getDefaultProps: ->
        autoFocus: true
        label: 'SalesOrder ID'

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
                    { id: 'po_num', title: 'PO'}
                    { id: 'notes', flex: 2}
                    { id: 'order_total', title: 'Total' }
                ]
            })


    render: ->
        <LC.RecordFinder ref="finder" sm=2
            {...@props}
            model={@props.model}
            name='visible_id'
            onModelSet={@props.onModelSet}
            label={@props.label}
            commands={@props.commands}
            query={@query} />
