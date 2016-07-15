class Filters extends Lanes.Models.State

    session:
        start_at: type: 'date', default: -> _.moment().subtract(1, 'week').toDate()
        end_at:   type: 'date', default: -> new Date()
        sku:      type: 'state'
        customer: type: 'state'

    derived:
        query: deps: ['start_at', 'end_at', 'sku', 'customer'], fn: ->
            options =
                with: {'with_details': true}
                query:
                    invoice_date:
                        op: 'in', value: [ @start_at.toISOString(), @end_at.toISOString() ]
            if @sku
                options['with']['with_sku_id'] = @sku.id
            if @customer
                options['query']['customer_id'] = @customer.id
            new Lanes.Models.Query
                title: 'Lines', src: Skr.Models.Invoice
                syncOptions: options
                fields: [
                    { id: 'id', visible: false }
                    { id: 'visible_id', title: 'Invoice #', fixedWidth: 100}
                    { id: 'invoice_date', title: 'Date', format: Lanes.u.format.shortDate, fixedWidth: 100 }
                    { id: 'customer_code', title: 'Customer', fixedWidth: 120}

                    { id: 'customer_name' }
                    {
                        id: 'invoice_total', title: 'Total', fixedWidth: 120,
                        textAlign: 'right', format: Lanes.u.format.currency
                    }
                ]


class Skr.Screens.SaleReport extends Skr.Screens.Base

    modelBindings:
        filters: -> new Filters

    resetQuery: ->
        @filters.clear()

    onPrint: (isPrinting) ->
        @setState({isPrinting})
        if isPrinting
            @filters.query.results.loadFully()


    render: ->
        props = {sm:3, xs: 4, writable: true, editOnly: true, model: @filters, step: 15}
        <LC.ScreenWrapper flexVertical identifier="sales-report">
            <BS.Panel header={
                <LC.PanelHeader title="Sales Report">
                    <SC.PrintButton onPrint={@onPrint} iconOnly />
                    <LC.Icon onClick={@resetQuery} type="repeat" noPrint />
                </LC.PanelHeader>
            }>
                <BS.Row>
                    <LC.DateTime  {...props} name="start_at"/>
                    <LC.DateTime  {...props} name="end_at"/>
                    <SC.SkuFinder {...props}
                        parentModel={@filters} associationName='sku' />
                    <SC.CustomerFinder {...props} name='code'
                        parentModel={@filters} associationName='customer' />

                </BS.Row>
            </BS.Panel>
            <LC.Grid
                renderCompleteResults={@state.isPrinting}
                query={@filters.query}  />
        </LC.ScreenWrapper>
