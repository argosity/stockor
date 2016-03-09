class Skr.Components.UOMChooser extends Lanes.React.Component

    propTypes:
        model: Lanes.PropTypes.Model.isRequired


    getDefaultProps: ->
        label: 'UOM'

    render: ->
        props = _.clone(@props)
        props.choices ||= @props.model.uom_choices.models
        <LC.SelectField
            key="uom"
            syncOptions={with: 'with_combined_uom'}
            displayFallback={@props.model.uom.combined_uom}
            editOnly writable unstyled
            model={@props.model}
            fetchWhenOpen={false}
            queryOrder={size: 'desc'}
            labelField="combined_uom"
            name="uom"
            {...props}
        />
