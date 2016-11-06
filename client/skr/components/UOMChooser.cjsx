class Skr.Components.UOMChooser extends Lanes.React.Component

    propTypes:
        model: Lanes.PropTypes.Model.isRequired


    getDefaultProps: ->
        label: 'UOM'

    render: ->
        props = _.clone(@props)
        props.choices ||= @props.model.uom_choices.models

        <LC.SelectField
            syncOptions={with: 'with_combined_uom'}
            fallBackValue={@props.model.uom.combined_uom}
            editOnly writable unstyled
            model={@props.model}
            fetchOnSelect={false}
            syncOptions={order: {size: 'desc'}}
            labelField="combined"
            name="uom"
            {...props}
        />
