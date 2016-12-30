class Skr.Components.EventChooser extends Lanes.React.Component

    propTypes:
        name:       React.PropTypes.string
        hideSingle: React.PropTypes.bool

    getDefaultProps: ->
        label: 'Event', name: 'event'

    modelBindings:
        query: ->
            new Lanes.Models.Query({
                autoRetrieve: true
                syncOptions: Lanes.Models.Query.mergedSyncOptions(
                    @props.syncOptions, { include: [ 'address' ] }
                )
                src: Skr.Models.Event, fields: [
                    {id:'id', visible: false}
                    { id: 'code', fixedWidth: 130 }
                    'title', 'starts_at'
                ]
            })

    render: ->
        props = _.omit(@props, 'hideSingle', 'displayFinder')

        if @props.hideSingle and Skr.Models.Event.all.length < 2
            return LC.SelectField.renderEmptyColumn(props)

        if @props.displayFinder
            <LC.RecordFinder ref="finder" sm=3 autoFocus
                commands={@state.commands}
                query={@query}
                {...props}
            />
        else
            <LC.SelectField {...props}
                fetchOnSelect={false}
                labelField='code'
                model={@props.model}
            />
