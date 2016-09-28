class Skr.Components.ToolbarButton extends Lanes.React.BaseComponent

    propTypes:
        onClick: React.PropTypes.func.isRequired
        className: React.PropTypes.string

    render: ->
        cn = _.classnames "navbar-btn", "control", @props.className
        <BS.NavItem onClick={@props.onClick} className={cn}>
            {@props.children}
        </BS.NavItem>
