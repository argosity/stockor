class Skr.Components.SalesOrderFinder extends Lanes.React.Component

    propTypes:
        onModelSet: React.PropTypes.func
        commands:   React.PropTypes.object
        name:       React.PropTypes.string
        autoFocus:  React.PropTypes.bool
        includeAssociations: React.PropTypes.array

    getDefaultProps: ->
        autoFocus: true, name: 'visible_id', label: 'Sales Order #'

    dataObjects:
        query: ->
            new Lanes.Models.Query({
                initialFieldIndex: 1
                title: 'Sales Order'
                include: @props.includeAssociations
                syncOptions: Lanes.Models.Query.mergedSyncOptions(
                    @props.syncOptions, { with: [ 'with_details' ] }
                )
                src: Skr.Models.SalesOrder, fields: [
                    { id: 'id', visible: false }
                    { id: 'visible_id', title: 'SO #' }
                    { id: 'customer_code' }
                    { id: 'po_num', title: 'PO'}
                    { id: 'notes', flex: 2}
                    {
                        id: 'order_total', title: 'Total', textAlign: 'right'
                        format: Lanes.u.format.currency
                    }
                ]
            })

    render: ->
        <LC.RecordFinder ref="finder" sm=2
            {...@props}
            query={@query}
        />
