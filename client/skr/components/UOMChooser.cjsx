class Skr.Components.UOMChooser extends Lanes.React.Component

    propTypes:
        model: Lanes.PropTypes.Model.isRequired

    getDefaultProps: ->
        label: 'UOM'

    render: ->
        props = _.clone(@props)
        props.collection ||= @props.model.uom_choices
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
