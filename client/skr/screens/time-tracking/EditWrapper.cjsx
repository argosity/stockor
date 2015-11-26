class Skr.Screens.TimeTracking.EditWrapper extends Lanes.React.Component

    componentWillMount: ->
        @props.parent.startEdit(this, this.props)

    componentWillUnmount: ->
        @props.parent.stopEdit(this, this.props)

    render: ->
        <div className="popover-edit-wrapper">{@props.children}</div>
