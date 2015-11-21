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

    constructor: ->
        super
        @available_projects = Skr.Models.CustomerProject.Collection.fetch()
        @entries = new Skr.Models.TimeEntry.Collection
        @listenTo(@entries, 'request sync', @onLoad)
        @entries.fetch()
        this.on('change:customer_project', @fetchEvents)

    onLoad: ->
        delete @_cachedEvents unless @entries.requestInProgress
        @isLoading = !!@entries.requestInProgress
        @trigger('change', @)

    fetchEvents: ->
        query = if @customer_project.id
            {customer_project_id: @customer_project.id}
        else
            {}
        query.end_at    = { op: 'gt', value: @range.start.toISOString() }
        query.start_at  = { op: 'lt', value: @range.end.toISOString() }
        @entries.fetch({query})

    calEvents: ->
        @_cachedEvents ||= new LC.Calendar.Events( @entries.invoke('toCalEvent') )

    back: ->
        @date.subtract(1, @display)
        @trigger('change', @)

    forward: ->
        @date.add(1, @display)
        @trigger('change', @)
