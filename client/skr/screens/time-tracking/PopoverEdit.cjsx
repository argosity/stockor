class Skr.Screens.TimeTracking.PopoverEdit extends Lanes.React.Component

    setDataState: (change) ->
        if change.event
            @props.entry.fromCalEvent(change.event)
            change.event.set({content: @props.entry.content}, {silent: true})
        @forceUpdate()

    getTarget: ->
        return null unless @props.wrapper.isMounted()
        _.dom(@props.wrapper).el

    onCancel: ->
        if @props.entry.isNew()
            @props.event.remove()
        else
            this.props.event.set(editing: false)

    onSave: ->
        event = @props.event
        @props.entry.save().then (te) ->
            event.set(_.extend({editing: false}, te.toCalEvent()))

    renderBody: ->
        dtp = {sm:12, editOnly: true, model: @props.entry}
        <div className="entry-body">
            <BS.Row>
                <LC.SelectField {...dtp} name='customer_project' labelField="code" />

                <LC.DateTime {...dtp} step={15} name="start_at"/>

                <LC.DateTime {...dtp} step={15} name="end_at"/>

                <LC.Input sm={12}
                    model={@props.entry}
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
        return null unless @props.entry

        placement = if @props.entries.display is 'day'
            if @props.entry.start_at.getHours() > 12 then 'top' else 'bottom'
        else
            if @props.entry.start_at.getDay() > 3 then 'left' else 'right'

        <Lanes.Vendor.Overlay.Position
            target={@getTarget}
            container={@props.container}
            placement={placement}
        >
            <BS.Popover title="Edit" id="edit">
                {@renderBody()}
            </BS.Popover>
        </Lanes.Vendor.Overlay.Position>
