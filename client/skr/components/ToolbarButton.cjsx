class Skr.Components.ToolbarButton extends Lanes.React.BaseComponent

    render: ->
        cn = _.classnames "navbar-btn", "control", @props.classNames
        <BS.Button navItem componentClass="button" {...@props} className={cn}>
            {@props.children}
        </BS.Button>
