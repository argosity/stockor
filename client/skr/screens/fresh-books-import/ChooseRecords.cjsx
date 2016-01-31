USERS = new Lanes.Models.User.Collection
USERS.ensureLoaded()
IGNORED_PROPS = ['selected', 'mapped_user_id']
class UserSelect extends Lanes.React.Component
    dataObjects:
        user: -> new Lanes.Models.User

    getUser: ->
        if @props.row.mapped_user_id
            user = USERS.get(@props.row.mapped_user_id)
            label: user.login, id: user.id
        else null
    setUser: (val, user) ->
        @props.row.mapped_user_id = user.id

    render: ->
        <LC.SelectField
            editOnly unstyled
            model={this.user}
            name="user"
            labelField='login'
            getSelection={@getUser}
            setSelection={@setUser}
            collection={USERS}
            fetchWhenOpen={false}
        />


class RecordRow extends Lanes.React.BaseComponent
    isChecked: -> not @props.row.selected? or @props.row.selected
    onChange: (ev) ->
        @props.row.selected = ev.target.checked
        @forceUpdate()
    onRowClick: ->
        @props.row.selected = if @props.row.selected? then !@props.row.selected else false
        @forceUpdate()
    render: ->
        <tr onClick={@onRowClick}>
            <td>
                <input type="checkbox" onChange={@onChange} checked={@isChecked()} />
            </td>
        {for key, value of _.omit(@props.row, IGNORED_PROPS)
            <th key={key}>{value}</th>}
        {for Field in (@props.xtra || [])
            <th key={Field.label}><Field.control row={@props.row} /></th>}
        </tr>

class Skr.Screens.FreshBooksImport.ChooseRecords extends Lanes.React.Component
    listenNetworkEvents: true
    dataObjects:
        import: 'props'
        job: -> @props.import.job

    RecordTable: (props) ->
        records = @import.recordsForType(props.type)
        keys = _.without( _.keys(_.first(records)), IGNORED_PROPS)
        xtraFields = []
        if props.type is 'staff'
            xtraFields.push { label: 'Reassign To', control: UserSelect }
        <BS.Table responsive striped bordered condensed hover
            className={props.type} >
            <thead>
                <tr>
                    <th>Select</th>
                {for key, i in keys
                    <th key={i}>{_.titleize _.humanize key}</th>}
                {for field in xtraFields
                    <th key={field.label}>{field.label}</th>}
                </tr>
            </thead>
            <tbody>
            {for row, i in records
                <RecordRow key={i} row={row} xtra={xtraFields} />}
            </tbody>
        </BS.Table>

    startImport: -> @import.complete()

    render: ->
        return null unless @import.hasPendingRecords()
        <div className="import-records">
            <div className="header">
                <h3>Select Records for Import</h3>
                <BS.Button bsStyle="primary" bsSize="large" onClick={@startImport}>
                    Start Import
                </BS.Button>
            </div>
            <BS.Tabs animation={false} defaultActiveKey={0}>
            {for type, i in @import.recordTypes
                <BS.Tab eventKey={i} key={i} title={_.titleize(type)} animation={false}>
                    <@RecordTable type={type} />
                </BS.Tab>}
            </BS.Tabs>
        </div>
