class Skr.Components.InvoiceFinder extends Lanes.React.Component

    propTypes:
        commands:   React.PropTypes.object
        autoFocus:  React.PropTypes.bool

    getDefaultProps: ->
        autoFocus: true, name: 'visible_id', label: 'Invoice #'

    modelBindings:
        query: ->
            new Lanes.Models.Query({
                initialFieldIndex: 1
                title: 'Invoice'
                defaultSort: 'visible_id', sortAscending: false
                syncOptions: Lanes.Models.Query.mergedSyncOptions(
                    @props.syncOptions, { with: [ 'with_details' ] }
                ), autoRetrieve: true
                src: Skr.Models.Invoice, fields: [
                    { id: 'id', visible: false }
                    { id: 'visible_id', title: 'Invoice #', fixedWidth: 100}
                    { id: 'customer_code', title: 'Customer', fixedWidth: 120}
                    { id: 'invoice_date', fixedWidth: 120}
                    { id: 'po_num', title: 'PO', fixedWidth: 120}
                    { id: 'notes', flex: 1}
                    {
                        id: 'invoice_total', title: 'Total', fixedWidth: 120,
                        textAlign: 'right', format: Lanes.u.format.currency
                    }
                ]
            })

    render: ->
        <LC.RecordFinder ref="finder" sm=2
            name='customer' inputType="number"
            {...@props}
            query={@query}
        />
