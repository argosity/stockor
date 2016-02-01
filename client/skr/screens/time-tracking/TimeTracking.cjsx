##= require_self
##= require ./EditWrapper
##= require ./PopoverEdit
##= require ./WeekSummary
##= require ./Entries

class Skr.Screens.TimeTracking extends Skr.Screens.Base

    dataObjects:
        entries: ->
            new Skr.Screens.TimeTracking.Entries

    back: ->
        @entries.back()

    forward: ->
        @entries.forward()

    onAddEntry: (ev, date) ->
        @entries.stopEditing()
        rounded = Math.round( date.minute() / 15 ) * 15
        date.minute(rounded).second(0)
        entry = @entries.add(
            start_at: date, end_at: date.clone().add(2, 'hour')
        )
        event = @entries.calEvents().add( _.extend(entry.toCalEvent(), {
            onTop: (0.5 < ev.clientY / this.context.viewport.domRoot.clientHeight)
            onLeft: (0.5 < ev.clientX / this.context.viewport.domRoot.clientWidth)
        }))
        @entries.startEditing(event)

    onEventClick: (ev, event) ->
        if event.isEditing() then event.set(editing: false) else @entries.startEditing(event)

    editComponent: (props) ->
        <Skr.Screens.TimeTracking.EditWrapper {...props} parent={this} />

    startEdit: (wrapper, edit) ->
        @setState({edit: {
            wrapper, entries: @entries, container: @, event: edit.event,
            entry: edit.event.get('entry')
        }})

    stopEdit: ->
        @setState(edit: false)

    onEventResize: (ev, event) ->
        entry = event.get('entry')
        entry.fromCalEvent(event)
        entry.save() unless entry.isNew()

    changeDisplay: (ev) ->
        @entries.display = ev.target.value

    ProjectOption: (props) ->
        color = props.item.options?.color || 0
        <div className={"color-#{color}"}>{props.item.code}</div>

    setProject: (project) ->
        @entries.set(customer_project_id: project.id)

    getProjects: ->
        @entries.available_projects.models

    renderSummaryDays: ->
        return null unless @entries.isMonth
        for week in [1..5]
            <Skr.Screens.TimeTracking.WeekSummary
                key={week} week={week} entries={@entries} />

    renderTotals: ->
        return null unless @entries.isMonth
        <div className="monthly-totals">{@entries.totalHours().toFixed(2)}</div>

    render: ->
        <LC.ScreenWrapper identifier="time-tracking">
            <LC.NetworkActivityOverlay visible={@entries.isLoading} model={@entries}/>
            <BS.Row className='calendar-header'>

                <div className="paging">

                    <span className="legend">
                        {@entries.calLegend}
                    </span>

                    <BS.ButtonGroup>
                        <BS.Button bsSize="small" onClick={@back}>
                            <LC.Icon size='2x' type="caret-left" />
                        </BS.Button>
                        <BS.Button bsSize="small" onClick={@forward}>
                            <LC.Icon size='2x' type="caret-right"  />
                        </BS.Button>
                    </BS.ButtonGroup>

                </div>

                <div className="display">
                   <BS.ButtonGroup>
                       <BS.Button
                           value='month' onClick={@changeDisplay}
                           active={@entries.display == 'month'}>Month</BS.Button>

                       <BS.Button
                           value='week' onClick={@changeDisplay}
                           active={@entries.display == 'week'}>Week</BS.Button>

                       <BS.Button
                           value='day' onClick={@changeDisplay}
                           active={@entries.display == 'day'}>Day</BS.Button>
                    </BS.ButtonGroup>
                </div>

                <div className="select">
                    <Lanes.Vendor.ReactWidgets.DropdownList
                        data={@getProjects()}
                        valueField='id' textField='code'
                        value={@entries.project}
                        onChange={@setProject}
                        valueComponent={@ProjectOption}
                        itemComponent={@ProjectOption}
                    />
                </div>

            </BS.Row>
            <BS.Row className="calendar-panel">
                <Skr.Screens.TimeTracking.PopoverEdit {...@state.edit} />
                {@renderTotals()}
                <LC.Calendar ref='calendar'
                    displayHours={[6, 20]}
                    onDayClick={@onAddEntry}
                    onEventResize={@onEventResize}
                    onEventClick={@onEventClick}
                    editComponent={@editComponent}
                    date={@entries.date}
                    events={@entries.calEvents()}
                    display={@entries.display}
                >
                    {@renderSummaryDays()}
                </LC.Calendar>
            </BS.Row>
        </LC.ScreenWrapper>
