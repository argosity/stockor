class Skr.Components.UOMChooser extends Lanes.React.Component

    propTypes:
        model: Lanes.PropTypes.Model.isRequired

    getDefaultProps: ->
        label: 'UOM'

    render: ->
        props = if (not @props.model.uom_choices or @props.model.uom_choices.isEmpty()) then {}
        else {collection: @props.model.uom_choices}
        <LC.SelectField
            key="uom"
            displayFallback={@props.model.uom.combined}
            editOnly writable unstyled
            model={@props.model}
            fetchWhenOpen={false}
            queryOrder={size: 'desc'}
            labelField="combined"
            name="uom"
            {...props}
        />
