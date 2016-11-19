class Skr.Components.SalesOrderFinder extends Lanes.React.Component

    propTypes:
        onModelSet: React.PropTypes.func
        commands:   React.PropTypes.object
        name:       React.PropTypes.string
        autoFocus:  React.PropTypes.bool

    getDefaultProps: ->
        autoFocus: true, name: 'visible_id', label: 'Sales Order #'

    modelBindings:
        query: ->
            new Lanes.Models.Query({
                initialFieldIndex: 1, title: 'Sales Order', autoRetrieve: true
                defaultSort: 'visible_id', sortAscending: false
                syncOptions: Lanes.Models.Query.mergedSyncOptions(
                    @props.syncOptions, { with: [ 'with_details' ] }
                )
                src: Skr.Models.SalesOrder, fields: [
                    { id: 'id', visible: false }
                    { id: 'visible_id', title: 'SO #', fixedWidth: 100}
                    { id: 'customer_code', title: 'Customer', fixedWidth: 150}
                    { id: 'order_date', fixedWidth: 120}
                    { id: 'po_num', title: 'PO', fixedWidth: 120}
                    { id: 'notes', flex: 1}
                    {
                        id: 'order_total', title: 'Total', textAlign: 'right', fixedWidth: 120,
                        format: Lanes.u.format.currency
                    }
                ]
            })

    render: ->
        <LC.RecordFinder ref="finder" sm=2
            {...@props} inputType="number"
            query={@query}
        />
