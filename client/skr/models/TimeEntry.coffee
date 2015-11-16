class Skr.Models.TimeEntry extends Skr.Models.Base

    props:
        id:                 {"type":"integer"}
        customer_project_id:{"type":"integer"}
        lanes_user_id:      {"type":"integer", default: ->
            Lanes.current_user.id
        }
        is_invoiced:        {"type":"boolean", default:false}
        start_at:           {"type":"date",    default: ->
            new Date
        }
        end_at:             {"type":"date", default: ->
            d = new Date; d.setHours(d.getHours() + 1)
        }
        description:        {"type":"string", default: 'New Event'}

    associations:
        customer_project: { model: "CustomerProject" }

    derived:
        range: deps: ['start_at', 'end_at'], fn: ->
            _.moment.range(@start_at, @end_at)

        content: deps: ['start_at', 'end_at', 'description'], fn: ->
            this.range.end.diff(this.range.start, 'hour', true).toFixed(2) +
                " hours: " + @description

    toCalEvent: ->
        {entry: this, range: @range, content: @content, resizable: {step: 15}}

    fromCalEvent: (event) ->
        attrs =
            id: event.entryId,
            start_at:    event.start()
            end_at:      event.end()
        this.set(_.pick(attrs, _.identity))
