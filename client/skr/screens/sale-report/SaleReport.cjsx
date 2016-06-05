class Filters extends Lanes.Models.State

    session:
        start_at: type: 'date', default: -> _.moment().subtract(1, 'week').toDate()
        end_at:   type: 'date', default: -> new Date()
        sku:      type: 'state'
        customer: type: 'state'

    derived:
        query: deps: ['start_at', 'end_at', 'sku'], fn: ->
            new Lanes.Models.Query
                title: 'Lines', src: Skr.Models.Invoice
                syncOptions:
                    with: ['with_details']
                    query:
                        invoice_date:
                            op: 'in', value: [ @start_at.toISOString(), @end_at.toISOString() ]

                fields: [
                    { id: 'id', visible: false }
                    { id: 'invoice_date', title: 'Date', format: Lanes.u.format.shortDate, fixedWidth: 100 }

                    { id: 'customer_name' }
                    {
                        id: 'invoice_total', title: 'Total', fixedWidth: 120,
                        textAlign: 'right', format: Lanes.u.format.currency
                    }
                ]


class Skr.Screens.SaleReport extends Skr.Screens.Base

    dataObjects:
        filters: -> new Filters

    render: ->
        props = {sm:3, xs: 4, writable: true, editOnly: true, model: @filters, step: 15}
        <LC.ScreenWrapper flexVertical identifier="sales-report">
            <BS.Row>
                <h3>Sales</h3>
            </BS.Row>
            <BS.Row>
                <LC.DateTime  {...props} name="start_at"/>
                <LC.DateTime  {...props} name="end_at"/>
                <SC.SkuFinder {...props}
                    parentModel={@filters} associationName='sku' />
                <SC.CustomerFinder {...props} name='code'
                    parentModel={@filters} associationName='customer' />
            </BS.Row>
            <LC.Grid query={@filters.query} />
        </LC.ScreenWrapper>
