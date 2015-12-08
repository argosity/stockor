class TimeEntries extends Skr.Models.TimeEntry.Collection

    constructor: (@projects) ->
        super()

    projectForEntry: (entry) ->
        @projects.get( entry.customer_project_id )

    load: (range, query = {}) ->
        query.end_at    = { op: 'gt', value: range.start.toISOString() }
        query.start_at  = { op: 'lt', value: range.end.toISOString() }
        @fetch({query})

    reset: (projectId, range) ->
        @projectId = projectId
        query = if @projectId and @projectId isnt -1
            {customer_project_id: @projectId}
        else {}
        @load(range, query)

class Skr.Screens.TimeTracking.Entries extends Lanes.Models.Base

    session:
        date:    { type: 'object', 'required': true, default: -> _.moment() }
        display: { type: 'string', values: ['day', 'week', 'month'], default: 'week' }
        isLoading: { type: 'boolean', default: false }
        customer_project_id: 'integer'

    derived:
        project:
            deps: ['customer_project_id'], fn: ->
                @available_projects.get(@customer_project_id)

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

    events:
        'change:range': 'fetchEvents'
        'change:customer_project_id': 'fetchEvents'

    constructor: ->
        super
        @available_projects = Skr.Models.CustomerProject.Collection
            .fetch().whenLoaded (cp) =>
                cp.add({id:-1, code: 'ALL', options:{color: 1}}, at: 0)
                @set(customer_project_id: -1)
        @entries = new TimeEntries(@available_projects)
        @listenTo(@entries, 'sync', @onLoad)

    startEditing: (editingEvent) ->
        for event in @calEvents().events
            event.set(editing: (event is editingEvent))

    add: (attrs) ->
        attrs.customer_project = @project unless @project.id is -1
        @entries.add(attrs)

    onLoad: ->
        delete @_cachedEvents unless @entries.requestInProgress
        @isLoading = !!@entries.requestInProgress
        @trigger('change', @)

    reset: ->
        @entries.load(@range)

    fetchEvents: ->
        @entries.reset(@customer_project_id, @range)

    calEvents: ->
        @_cachedEvents ||= new LC.Calendar.Events( @entries.invoke('toCalEvent') )

    back: ->
        @date = @date.clone().subtract(1, @display)
        @trigger('change', @)

    forward: ->
        @date = @date.clone().add(1, @display)
        @trigger('change', @)
