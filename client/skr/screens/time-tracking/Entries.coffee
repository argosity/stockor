class TimeEntries extends Skr.Models.TimeEntry.Collection

    constructor: (@projects) ->
        super()

    projectForEntry: (entry) ->
        @projects.get( entry.customer_project_id )

    setProject: (project, range) ->
        return if @project_id is project.id
        @project_id = project.id
        query = if @project_id then {customer_project_id: @project_id} else {}
        query.end_at    = { op: 'gt', value: range.start.toISOString() }
        query.start_at  = { op: 'lt', value: range.end.toISOString() }
        @fetch({query})

class Skr.Screens.TimeTracking.Entries extends Lanes.Models.Base

    session:
        date:    { type: 'object', 'required': true, default: -> _.moment() }
        display: { type: 'string', values: ['day', 'week', 'month'], default: 'week' }
        isLoading: { type: 'boolean', default: false }

    derived:
        range:
            deps: ['date', 'display'], fn: ->
                range = _.moment.range(
                    @date.clone().startOf( @display ), @date.clone().endOf( @display )
                )
                if 'month' == @display
                    range.start.subtract(range.start.weekday(), 'days')
                    range.end.add(6 - range.end.weekday(), 'days')
                range

        calLegend:
            deps: ['date', 'display'], fn: ->
                @date.format('MMMM YYYY')

    associations:
        customer_project: { model: "CustomerProject" }

    events:
        'change:customer_project': 'fetchEvents'

    constructor: ->
        super
        @available_projects = Skr.Models.CustomerProject.Collection.fetch()
        @entries = new TimeEntries(@available_projects)
        @listenTo(@entries, 'sync', @onLoad)
        @entries.fetch()

    startEditing: (editingEvent) ->
        for event in @calEvents().events
            event.set(editing: (event is editingEvent))

    onLoad: ->
        delete @_cachedEvents unless @entries.requestInProgress
        @isLoading = !!@entries.requestInProgress
        @trigger('change', @)

    fetchEvents: (project) ->
        @entries.setProject(project, @range)

    calEvents: ->
        @_cachedEvents ||= new LC.Calendar.Events( @entries.invoke('toCalEvent') )

    back: ->
        @date.subtract(1, @display)
        @trigger('change', @)

    forward: ->
        @date.add(1, @display)
        @trigger('change', @)
