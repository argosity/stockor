class Skr.Screens.TimeTracking.MiniControls extends Lanes.React.Component

    onEditEvent: ->
        @props.onEditEvent(@props.event)

    EditButton: ->
        return null unless @props.event
        <BS.Button onClick={@onEditEvent} title="Edit Time Entry">
            <LC.Icon type='pencil-square-o' 2x flush />
        </BS.Button>

    render: ->
        <div className="mini-controls">
            <div className='l'>
                <span>{@props.date.format('MMM')}</span>
                <span>{@props.date.format('Do')}</span>
            </div>
            <BS.Button onClick={@props.onCancel} title="Hide Controls">
                <LC.Icon type='ban' 2x flush />
            </BS.Button>
            <@EditButton />
            <BS.Button onClick={@props.onAddEntry} title="Create Time Entry">
                <LC.Icon type='plus-square' 2x flush />
            </BS.Button>
        </div>
