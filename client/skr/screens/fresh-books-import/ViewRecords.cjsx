# coffeelint: disable=max_line_length
class Skr.Screens.FreshBooksImport.ViewRecords extends Lanes.React.Component
    listenNetworkEvents: true
    modelBindings:
        import: 'props'
        job: -> @props.import.job

    getCustomer: (id) ->
        _.find @import.recordsForType('clients'), (c) -> c.id is id

    Staff: (props) ->
        <BS.Table responsive striped bordered condensed hover>
            <thead>
                <tr>
                    <th>Login</th><th>Name</th><th>Email</th>
                </tr>
            </thead>
            <tbody>
            {for row, i in props.records
                <tr key={i}><td>{row.login}</td><td>{row.name}</td><td>{row.email}</td></tr>}
            </tbody>
        </BS.Table>

    Clients: (props) ->
        <BS.Table responsive striped bordered condensed hover>
            <thead>
                <tr><th>Code</th><th>Name</th><th>Notes</th></tr>
            </thead>
            <tbody>
            {for row, i in props.records
                cust = new Skr.Models.Customer(row)
                <tr key={i}>
                    <td><SC.CustomerLink customer={cust} /></td>
                    <td>{row.name}</td><td>{row.notes}</td>
                </tr>}
            </tbody>
        </BS.Table>

    Projects: (props) ->
        <BS.Table responsive striped bordered condensed hover>
            <thead>
                <tr><th>Code</th><th>Description</th><th>Customer</th></tr>
            </thead>
            <tbody>
            {for row, i in props.records
                <tr key={i}>
                    <td>{row.code}</td><td>{row.description}</td>
                    <td>{@getCustomer(row.customer_id)?.code}</td>
                </tr>}
            </tbody>
        </BS.Table>

    Invoices: (props) ->
        <BS.Table responsive striped bordered condensed hover>
            <thead>
                <tr><th>ID</th><th>Customer</th><th>Date</th><th>Notes</th></tr>
            </thead>
            <tbody>
            {for row, i in props.records
                inv = new Skr.Models.Invoice(row)
                <tr key={i}>
                    <td><SC.InvoiceLink invoice={inv} /></td><td>{@getCustomer(row.customer_id)?.code}</td>
                    <td>{row.invoice_date}</td><td>{row.notes}</td>
                </tr>}
            </tbody>
        </BS.Table>

    Time_entries: (props) ->
        <BS.Table responsive striped bordered condensed hover>
            <thead>
                <tr><th>Start At</th><th>End At</th><th>Description</th></tr>
            </thead>
            <tbody>
            {for row, i in props.records
                <tr key={i}>
                    <td>{row.start_at}</td><td>{row.end_at}</td>
                    <td>{row.description}</td>
                </tr>}
            </tbody>
        </BS.Table>


    BlankTable: (props) ->
        <span />

    render: ->
        return null unless @import.hasImportedRecords()

        <h3>Import Success!</h3>
        <BS.Tabs id='view-records'>
        {for type, i in @import.recordTypes
            TableType = @[_.capitalize(type)] || @BlankTable
            <BS.Tab eventKey={i} key={i} title={_.titleize(type)} animation={false}>
                <TableType type={type} records={@import.recordsForType(type)} />
            </BS.Tab>}
        </BS.Tabs>
