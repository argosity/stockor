class Skr.Screens.TimeTracking.PopoverEdit extends Lanes.React.Component

    dataObjects:
        event: ->
            this.props.event.isState = true
            this.props.event
        entry: ->
            entry = @props.event.get('entry')
            project = if entry.customer_project_id
                @props.entries.available_projects.get(entry.customer_project_id)
            else
                @props.entries.customer_project
            entry.set(customer_project: project)
            entry

    setDataState: (change) ->
        if change.event
            @entry.fromCalEvent(change.event)
            change.event.set({content: @entry.content}, {silent: true})
        @forceUpdate()


    getTarget: ->
        _.dom(this.props.parent).el

    onCancel: ->
        this.props.event.set(editing: false)

    onSave: ->
        @entry.save().then (te) =>
            @props.event.set(_.extend({editing: false}, te.toCalEvent()))

    renderBody: ->
        dtp = {sm:12, editOnly: true, model: @entry}
        <div className="entry-body">
            <BS.Row>
                <LC.SelectField {...dtp} name='customer_project' labelField="code" />

                <LC.DateTime {...dtp} step={15} name="start_at"/>

                <LC.DateTime {...dtp} step={15} name="end_at"/>

                <LC.Input sm={12}
                    model={@entry}
                    autoFocus editOnly
                    name="description"
                    type="textarea"
                    label='Description'
                />
            </BS.Row>
            <BS.Row className="controls">
                <BS.Button onClick={@onCancel}>Cancel</BS.Button>
                <BS.Button onClick={@onSave} bsStyle="primary">Save</BS.Button>
            </BS.Row>
        </div>

    render: ->
        placement = if this.props.event.get('onLeft') then 'left' else 'right'
        <Lanes.Vendor.Overlay.Position
            target={@getTarget}
            container={@props.parent}
            placement={placement}
        >
            <BS.Popover title="Edit" id="edit">
                {@renderBody()}
            </BS.Popover>
        </Lanes.Vendor.Overlay.Position>
