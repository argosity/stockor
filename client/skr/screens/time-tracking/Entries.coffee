class TimeEntries extends Skr.Models.TimeEntry.Collection

    constructor: (@projects) ->
        super()

    projectForEntry: (entry) ->
        @projects.get( entry.customer_project_id )

    loadEntries: (range, query = {}) ->
        query.end_at    = { op: 'gt', value: range.start.toISOString() }
        query.start_at  = { op: 'lt', value: range.end.toISOString() }
        @fetch({query, reset: true})

    resetEntries: (projectId, range) ->
        @projectId = projectId
        query = if @projectId and @projectId isnt -1
            {customer_project_id: @projectId}
        else {}
        @loadEntries(range, query)

class Skr.Screens.TimeTracking.Entries extends Lanes.Models.Base

    session:
        date:    { type: 'object', 'required': true, default: -> _.moment() }
        display: { type: 'string', values: ['day', 'week', 'month'], default: 'week' }
        isLoading: { type: 'boolean', default: false }
        customer_project_id: 'integer'
        editing: 'any'

    derived:
        project:
            deps: ['customer_project_id'], fn: ->
                @available_projects.get(@customer_project_id)
        isMonth:
            deps: ['display'], fn: -> 'month' == @display
        range:
            deps: ['date', 'isMonth'], fn: ->
                _.moment.range(
                    @date.clone().startOf( @display ), @date.clone().endOf( @display )
                )

        calLegend:
            deps: ['range', 'display'], fn: ->
                if @display is 'month'
                    @date.format('MMMM YYYY')
                else if @display is 'week'
                    "#{@range.start.format('MMM Do')} - #{@range.end.format('MMM Do')}"
                else if @display is 'day'
                    @date.format('MMMM Do YYYY')

    events:
        'change:range': 'fetchEvents'
        'change:display': 'onDisplayChange'
        'change:customer_project_id': 'fetchEvents'

    constructor: ->
        super
        @available_projects = new Skr.Models.CustomerProject.Collection
        @listenTo(@available_projects, 'sync', @onProjectsRequest)
        @available_projects.ensureLoaded()
        @entries = new TimeEntries(@available_projects)
        @listenTo(@entries, 'request', @onRequest)
        @listenTo(@entries, 'sync', @onLoad)

    onProjectsRequest: ->
        @available_projects.add({id:-1, code: 'ALL', options:{color: 1}}, at: 0)
        @set(customer_project_id: Lanes.current_user.options.project_id or -1 )
        @trigger('change', @)

    startEditing: (editingEvent) ->
        for event in @calEvents().events
            event.setEditing(event is editingEvent)

    stopEditing: ->
        for event in @calEvents().events when event.isEditing()
            entry = event.get('entry')
            if entry.isNew()
                event.remove()
            else
                entry.setEditing(false)

    addEvent: (date) ->
        date = date.clone()
        rounded = Math.round( date.minute() / 15 ) * 15
        date.minute(rounded).second(0)
        entry = @entries.add({
            start_at: date.subtract(1, 'hour'), end_at: date.clone().add(2, 'hour')
            customer_project: @project unless @project.id is -1
        })
        @calEvents().add( entry.toCalEvent() )

    onRequest: ->
        @isLoading = !!@entries.requestInProgress
        @trigger('change', @)

    onLoad: ->
        delete @_cachedEvents unless @entries.requestInProgress
        @isLoading = !!@entries.requestInProgress
        @trigger('change', @)

    reset: ->
        @entries.loadEntries(@range.clone())

    fetchEvents: ->
        @entries.resetEntries(@customer_project_id, @range)

    calEvents: ->
        @_cachedEvents ||= new LC.Calendar.Events( @entries.invoke('toCalEvent') )

    back: ->
        @set(editing: false, date: @date.clone().subtract(1, @display) )

    forward: ->
        @set(editing: false, date: @date.clone().add(1, @display) )

    onDisplayChange: ->
        @editing = false

    totalHours: ->
        @entries.reduce( (sum, entry) =>
            sum.add( entry.lengthInRange(@range, 'hours') )
        , _.bigDecimal('0') )

    totalsForWeek: (week) ->
        start = @range.start.clone().add(week - 1, 'week').startOf('week')
        days = _.moment.range( start, start.clone().endOf('week') )
        entries = @entries.filter (entry) -> days.overlaps( entry.range )
        byProject = _.groupBy entries, (entry) -> entry.customer_project_id
        _.mapValues byProject, (entries, projectId) ->
            _.reduce( entries, (total, entry) ->
                total.plus(entry.lengthInRange(days, 'hours'))
            , _.bigDecimal('0'))
