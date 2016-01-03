SHARED_COLLECTION = new Skr.Models.Location.Collection

class Skr.Components.LocationChooser extends Lanes.React.Component

    propTypes:
        onModelSet: React.PropTypes.func
        name:       React.PropTypes.string

    getDefaultProps: ->
        label: 'Location', name: 'location'

    dataObjects:
        query: ->
            new Lanes.Models.Query({
                syncOptions: Lanes.Models.Query.mergedSyncOptions(
                    @props.syncOptions, { include: [ 'address' ] }
                )
                src: Skr.Models.Location, fields: [
                    {id:'id', visible: false}
                    { id: 'code', fixedWidth: 130 }
                    'name'
                ]
            })

    componentWillMount: ->
        SHARED_COLLECTION.ensureLoaded()

    render: ->
        props = _.clone(@props)
        if props.displayFinder
            <LC.RecordFinder ref="finder" sm=3 autoFocus
                commands={@state.commands}
                query={@query}
                {...props} />
        else
            <LC.SelectField
                {...props}
                collection={SHARED_COLLECTION}
                labelField='code'
                fetchWhenOpen={false}
                model={@props.model} />
