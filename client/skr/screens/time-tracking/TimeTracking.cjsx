class Skr.Screens.TimeTracking extends Skr.Screens.Base

    dataObjects:
        entries: ->
            new Skr.Screens.TimeTracking.Entries

    back: ->
        @entries.back()

    forward: ->
        @entries.forward()

    onAddEntry: (ev, date) ->
        rounded = Math.round( date.minute() / 15 ) * 15
        date.minute(rounded).second(0)
        entry = new Skr.Models.TimeEntry(start_at: date, end_at: date.clone().add(1, 'hour'))
        event = @entries.calEvents().add( _.extend(entry.toCalEvent(), {
            onLeft: (0.5 < ev.clientX / this.context.viewport.domRoot.clientWidth)
        }))
        @entries.startEditing(event)

    onEventClick: (ev, event) ->
        if event.isEditing() then event.set(editing: false) else @entries.startEditing(event)

    editComponent: (props) ->
        <Skr.Screens.TimeTracking.PopoverEdit {...props} entries={@entries} />

    onEventResize: (ev, event) ->
        entry = event.get('entry')
        entry.fromCalEvent(event)
        entry.save()

    render: ->
        <LC.ScreenWrapper identifier="time-tracking">
            <BS.Row className='calendar-header'>

                <BS.Col mdOffset=4 sm=4 className="paging">
                    <BS.Button bsSize="small" onClick={@back}>
                        <LC.Icon size='2x' type="caret-left" />
                    </BS.Button>

                    <span>
                        {@entries.calLegend}
                    </span>

                    <BS.Button bsSize="small" onClick={@forward}>
                        <LC.Icon size='2x' type="caret-right"  />
                    </BS.Button>
                </BS.Col>
                <BS.Col sm=4>
                    <LC.SelectField name='customer_project' labelField="code"
                        unstyled editOnly includeBlankRow
                        collection={@entries.available_projects}
                        model={@entries}
                    />
                </BS.Col>

            </BS.Row>
            <BS.Row className="flex-expand">
                <LC.Calendar ref='calendar'
                    displayHours={[6, 20]}
                    onDayClick={@onAddEntry}
                    onEventResize={@onEventResize}
                    onEventClick={@onEventClick}
                    editComponent={@editComponent}
                    date={@entries.date}
                    events={@entries.calEvents()}
                    display={@entries.display} />
            </BS.Row>
        </LC.ScreenWrapper>
