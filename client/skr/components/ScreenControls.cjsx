class SC.ScreenControls extends Lanes.React.Component

    propTypes:
        commands:        React.PropTypes.instanceOf(Lanes.Screens.Commands).isRequired
        toolbar:         React.PropTypes.bool
        errors:          React.PropTypes.bool
        networkActivity: React.PropTypes.bool
        toolbarProps:    React.PropTypes.object

    PrintButton: ->
        return null unless @props.commands.canPrint?()
        <SC.ToolbarButton onClick={@props.commands.printModel} className='print'>
            <LC.Icon type="print" />Print
        </SC.ToolbarButton>

    render: ->
        <Lanes.Screens.CommonComponents {...@props}>
            <@PrintButton />
            {@props.children}
        </Lanes.Screens.CommonComponents>
