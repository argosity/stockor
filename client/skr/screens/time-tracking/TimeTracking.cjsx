##= require_self
##= require ./Popover
##= require ./WeekSummary
##= require ./Entries
##= require ./Header

class Skr.Screens.TimeTracking extends Skr.Screens.Base

    dataObjects:
        entries: ->
            new Skr.Screens.TimeTracking.Entries

    onDayClick: (ev, date) ->
        @showPopup(ev, date)

    showPopup: (ev, date, eventEditing = false) ->
        rect = _.dom(this).el.getBoundingClientRect()
        @entries.editing = {
            event: eventEditing,
            date: date, bounds: rect,
            position: {x: ev.clientX - rect.left, y: ev.clientY - rect.top}
        }

    onEventClick: (ev, event) ->
        @showPopup(ev, event.start(), event)

    stopEdit: ->
        @entries.editing = false

    onEventResize: (ev, event) ->
        entry = event.get('entry')
        entry.setTimeFromCalEvent(event)
        entry.save() unless entry.isNew()

    renderSummaryDays: ->
        return null unless @entries.isMonth
        for week in [1..5]
            <Skr.Screens.TimeTracking.WeekSummary
                key={week} week={week} entries={@entries} />

    renderTotals: ->
        return null unless @entries.isMonth
        <div className="monthly-totals">{@entries.totalHours().toFixed(2)}</div>

    render: ->
        <LC.ScreenWrapper identifier="time-tracking" flexVertical>
            <Skr.Screens.TimeTracking.Popover entries={@entries} {...@entries.editing} />
            <LC.NetworkActivityOverlay visible={@entries.isLoading} model={@entries}/>
            <Skr.Screens.TimeTracking.Header entries={@entries} />
            <BS.Row className="calendar-panel">
                {@renderTotals()}
                <LC.Calendar ref='calendar'
                    onDayClick={@onDayClick}
                    onEventResize={@onEventResize}
                    onEventClick={@onEventClick}
                    date={@entries.date}
                    events={@entries.calEvents()}
                    display={@entries.display}
                >
                    {@renderSummaryDays()}
                </LC.Calendar>
            </BS.Row>
        </LC.ScreenWrapper>
