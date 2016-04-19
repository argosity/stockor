class Skr.Models.TimeEntry extends Skr.Models.Base

    props:
        id:                 {"type":"integer"}
        customer_project_id:{"type":"integer"}
        is_invoiced:        {"type":"boolean", default:false}
        lanes_user_id:      {"type":"integer", default: ->
            Lanes.current_user.id
        }
        start_at:           {"type":"date", required: true, default: ->
            new Date
        }
        end_at:             {"type":"date", required: true, default: ->
            d = new Date; d.setHours(d.getHours() + 1)
        }
        description:        {"type":"string", required: true, default: 'New Event'}

    session:
        hours: { "type":"bigdec" }



    associations:
        customer_project: { model: "CustomerProject", required: true }

    derived:
        range: deps: ['start_at', 'end_at'], fn: ->
            _.moment.range(@start_at, @end_at)

        content: deps: ['start_at', 'end_at', 'description'], fn: ->
            this.range.end.diff(this.range.start, 'hour', true).toFixed(2) +
                " hours: " + @description

    initialize: ->
        @updateHours() if @start_at and @end_at

    events:
        'change:end_at'   : 'onEndChange'
        'change:start_at' : 'onStartChange'
        'change:hours'    : 'onHoursChange'

    onEndChange: (te, val) ->
        @start_at = _.moment(@end_at).add(1, 'hour') if @start_at > @end_at
        @updateHours()
    onStartChange: (te, val) ->
        @end_at = _.moment(@start_at).add(1, 'hour') if @start_at > @end_at
        @updateHours()

    updateHours: ->
        @set('hours', _.moment(this.end_at).diff(this.start_at, 'hour', true).toFixed(2),
            silent: true)
    onHoursChange: ->
        hours = @hours || _.bigDecimal('0')
        @end_at = _.moment(@start_at).add(hours.toFixed(), 'hour').toDate()

    length: (duration = 'hour') ->
        @range.end.diff(@range.start, duration, true)

    lengthInRange: (range, duration = 'hour') ->
        _.moment.min(@range.end, range.end).diff(
            _.moment.max(@range.start, range.start), duration, true
        )

    toCalEvent: ->
        attrs = {entry: this, range: @range, content: @content, resizable: {step: 15}}
        project = @collection.projectForEntry(this)
        if project?.options
            _.extend attrs, colorIndex: project.options.color
        attrs

    fromCalEvent: (event) ->
        attrs =
            id: event.entryId,
            start_at:    event.start()
            end_at:      event.end()
        this.set(_.pick(attrs, _.identity))
