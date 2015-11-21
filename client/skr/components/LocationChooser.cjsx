SHARED_COLLECTION = new Skr.Models.Location.Collection

class Skr.Components.LocationChooser extends Lanes.React.Component

    propTypes:
        onModelSet: React.PropTypes.func
        name:       React.PropTypes.string

    getDefaultProps: ->
        label: 'Location', name: 'location'

    componentWillMount: ->
        SHARED_COLLECTION.ensureLoaded()

    render: ->
        props = _.clone(@props)

        <LC.SelectField
            {...props}
            collection={SHARED_COLLECTION}
            labelField='code'
            fetchWhenOpen={false}
            model={@props.model} />
