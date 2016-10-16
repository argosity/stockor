class Skr.Components.LocationChooser extends Lanes.React.Component

    propTypes:
        name:       React.PropTypes.string
        hideSingle: React.PropTypes.bool

    getDefaultProps: ->
        label: 'Location', name: 'location'

    modelBindings:
        query: ->
            new Lanes.Models.Query({
                autoRetrieve: true
                syncOptions: Lanes.Models.Query.mergedSyncOptions(
                    @props.syncOptions, { include: [ 'address' ] }
                )
                src: Skr.Models.Location, fields: [
                    {id:'id', visible: false}
                    { id: 'code', fixedWidth: 130 }
                    'name'
                ]
            })

    render: ->
        if @props.hideSingle and Skr.Models.Location.all.length < 2
            return LC.SelectField.renderEmptyColumn(@props)

        props = _.omit(@props, 'hideSingle')

        if props.displayFinder
            <LC.RecordFinder ref="finder" sm=3 autoFocus
                commands={@state.commands}
                collection={Skr.Models.Location.all}
                query={@query}
                {...props} />
        else
            <LC.SelectField {...props} choices={Skr.Models.Location.all.models}
                fetchOnSelect={false} labelField='code' model={@props.model} />
