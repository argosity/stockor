class Skr.Components.InvoiceFinder extends Lanes.React.Component

    propTypes:
        commands:   React.PropTypes.object
        autoFocus:  React.PropTypes.bool

    getDefaultProps: ->
        autoFocus: true, name: 'visible_id', label: 'Invoice #'

    dataObjects:
        query: ->
            new Lanes.Models.Query({
                initialFieldIndex: 1
                title: 'Invoice'
                syncOptions: Lanes.Models.Query.mergedSyncOptions(
                    @props.syncOptions, { with: [ 'with_details' ] }
                )
                src: Skr.Models.Invoice, fields: [
                    { id: 'id', visible: false }
                    { id: 'visible_id' }
                    { id: 'customer_code' }
                    { id: 'notes', flex: 2}
                    { id: 'invoice_total', title: 'Total', format: Lanes.u.format.currency }
                ]
            })

    render: ->
        <LC.RecordFinder ref="finder" sm=2
            name='customer'
            {...@props}
            query={@query}
        />
