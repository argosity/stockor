class Skr.Screens.TimeInvoicing extends Skr.Screens.Base

    getInitialState: ->
        isEditing: true
        commands: new Lanes.Screens.Commands(this, modelName: 'request')

    dataObjects:
        request: -> new InvoiceRequest
        query: ->
            @gridSelections = new LC.Grid.Selections(onChange: @updateTotal)
            new Lanes.Models.Query({
                defaultSort: 'start_at'
                src: Skr.Models.TimeEntry, fields: [
                    {id:'id', visible: false}
                    @gridSelections
                    {
                        id: 'start_at', fixedWidth: 200,
                        format: Lanes.u.format.shartDateTime
                    }, {
                        id: 'end_at', fixedWidth: 200,
                        format: Lanes.u.format.shartDateTime
                    }, {
                        id: 'hours', fixedWidth: 80, textAlign: 'center', editable: false,
                        query: false, format: (v, row) -> hoursForRow(row)
                    }
                    { id: 'description', flex: 1}
                ]
            })

    setDataState: (state) ->
        @updateTotal()
        @setState(state)

    updateTotal:  ->
        total = _.bigDecimal('0')
        rate = @request.customer_project.rates?.hourly
        return unless rate # the first call is when the model isn't parsed yet
        @query.results.eachRow (row, xd) ->
            return if xd and not xd.selected
            total = total.add( hoursForRow(row) * rate )
        @setState(total: total )

    editors: ->
        selected:  ({query, rowIndex}) ->
            x = query.results.xtraData(rowIndex)
            <input type="checkbox" defaultChecked={x.selected}
                onChange={-> x.selected = ev.target.checked} />

    onModelSet: (project) ->
        @request.set(customer_project: project)
        @query.syncOptions = {
            query: { customer_project_id: project.id, is_invoiced: false }
        }
        @query.results.reload()

    createInvoice: ->
        idIndex = @query.idIndex
        @query.results.eachRow (row, xd) =>
            return if xd and not xd.selected
            @request.time_entry_ids.push(row[idIndex])
        @request.save(saveAll: true).then (req) =>
            @query.results.reload()
            @context.viewport.displayModal(@displayInvoiceResults(req))

    displayInvoiceResults: (req) ->
        title: "Invoice created …"
        buttons: [{ title: 'OK', style: 'primary' }]
        autoHide: true
        body: =>
            <h3>
                Invoice # <SC.InvoiceLink invoice={req.invoice}
                    onClick={ => @context.viewport.hideModal() }
                /> was successfully created.
            </h3>

    setNewEntriesProject: (entry) ->
        entry.set({customer_project: @request.customer_project})

    render: ->
        <LC.ScreenWrapper identifier="customer-projects" flexVertical>
            <BS.Nav className="lanes-toolbar">
                <div className="spacer"/>
                <BS.Button navItem componentClass="button"}
                    onClick={@createInvoice} className="save navbar-btn">
                    <LC.Icon type="file-text" /> Create Invoice
                </BS.Button>
            </BS.Nav>
            <BS.Row>
                <SC.CustomerProjectFinder name='code' ref="prjfinder"
                    model={@request.customer_project}
                    onModelSet={@onModelSet}
                />
            </BS.Row>
            <BS.Row className="flex-expand">
                <LC.Grid query={@query}
                    commands={@state.commands}
                    autoLoadQuery={false}
                    expandY={true}
                    columEditors={@editors()}
                    editorProps={syncImmediatly: true, beforeSave: @setNewEntriesProject, afterSave: @updateTotal}
                    onSelectionChange={@onSelectionChange}
                    height=200
                    allowDelete={true}
                    allowCreate={true}
                    editor={true}
                />
            </BS.Row>
            <BS.Row>
                <BS.Col xsOffset=10 xs=1>
                    <h4>Total:</h4>
                </BS.Col>
                <BS.Col xs=1>
                    <h4><SC.Currency amount={@state.total} /></h4>
                </BS.Col>

            </BS.Row>

        </LC.ScreenWrapper>


hoursForRow = (row) ->
    [from, to] = if _.isArray(row) then [ row[2], row[1] ] else [row.end_at, row.start_at]
    hours = _.moment(from).diff(to, 'hours', true)
    Math.round(hours * 100) / 100

class InvoiceRequest extends Lanes.Models.Base

    props:
        customer_project_id:{"type":"integer"}
        time_entry_ids: { type: 'array', default: -> [] }

    api_path: ->
        'invoices/from-time-entries'

    associations:
        customer_project: { model: "CustomerProject", autoCreate: true }
        invoice: { model: 'Invoice' }
