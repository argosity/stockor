##= require ./PopoverMiniControls
##= require ./EditEntry

MARGIN = 10
class Skr.Screens.TimeTracking.Popover extends Lanes.React.Component

    componentWillReceiveProps: (nextProps) ->
        if @state.editing and nextProps.editing is false
            @onCancel()
        else
            @setState(isCanceled: false)

    onCancel: ->
        entry = @state.editing.get('entry')
        if entry.isNew()
            @state.editing.remove()
            @props.entries.removeEntry(entry)

        @props.entries.stopEditing()
        @setState(isCanceled: true, editing: null)

    onAddEntry: ->
        event = @props.entries.addEvent(@props.date)
        @setState(editing: event)

    onEditEvent: (event) ->
        @setState(editing: event)

    EditEntry: ->
        return null unless @state.editing
        <Skr.Screens.TimeTracking.EditEntry
            event={@state.editing}
            entries={@props.entries}
            date={@props.date}
            onCancel={@onCancel}
        />

    MiniControls: ->
        return null if @state.editing
        <Skr.Screens.TimeTracking.MiniControls
            date={@props.date}
            event={@props.event}
            onCancel={@onCancel}
            onAddEntry={@onAddEntry}
            onEditEvent={@onEditEvent}
        />

    render: ->
        return null if @state.isCanceled or not @props.date

        classes = _.classnames('edit-control', 'in')
        {x, y} = @props.position
        [width, height] = if @state.editing
            [320, 400]
        else
            [175, 60]

        width += 60 if @props.event and not @state.editing
        placement = if x > (@props.bounds.width / 2) then 'left' else 'right'
        x -= width if placement is 'left'
        top = Math.max( MARGIN, y - (height / 2) )
        if top + height > @props.bounds.height
            top = @props.bounds.height - height - MARGIN

        <BS.Popover className={classes}
            style={{width, height}}
            id='edit-controls'
            arrowOffsetTop={y - top}
            placement={placement}
            positionLeft={x}
            positionTop={top}
        >
            <@MiniControls />
            <@EditEntry />
        </BS.Popover>
