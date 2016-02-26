class SC.ScreenControls extends Lanes.React.Component

    propTypes:
        commands:        React.PropTypes.instanceOf(Lanes.Screens.Commands).isRequired
        toolbar:         React.PropTypes.bool
        errors:          React.PropTypes.bool
        networkActivity: React.PropTypes.bool
        toolbarProps:    React.PropTypes.object

    renderPrintButton: ->
        <BS.Button navItem componentClass="button"
            onClick={@props.commands.printModel} className="print navbar-btn control">
            <LC.Icon type="print" />Print
        </BS.Button>

    render: ->
        <Lanes.Screens.CommonComponents {...@props}>
            {@renderPrintButton() if @props.commands.canPrint?()}
        </Lanes.Screens.CommonComponents>
