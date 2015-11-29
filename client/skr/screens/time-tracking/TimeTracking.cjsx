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

        #     <div className="day" style={{order: 6}}>A</div>
        #     <div className="day" style={{order: 13}}>B</div>
        #     <div className="day" style={{order: 20}}>C</div>
        #     <div className="day" style={{order: 27}}>D</div>
        #     <div className="day" style={{order: 34}}>E</div>

    render: ->
        <LC.ScreenWrapper identifier="time-tracking">
            <BS.Row className='calendar-header'>
                <div className="display">
                    <label>
                        Month: <input type="radio"
                                      name="style" value="month" onChange={@changeDisplay}
                                      checked={@entries.display == 'month'} />
                    </label><label>
                        Week: <input type="radio"
                                     name="style" value="week" onChange={@changeDisplay}
                                     checked={@entries.display == 'week'} />
                    </label><label>
                        Day: <input type="radio"
                                    name="style" value="day" onChange={@changeDisplay}
                                    checked={@entries.display == 'day'} />
                    </label>
                </div>

                <div className="paging">
                    <BS.Button bsSize="small" onClick={@back}>
                        <LC.Icon size='2x' type="caret-left" />
                    </BS.Button>

                    <span className="legend">
                        {@entries.calLegend}
                    </span>

                    <BS.Button bsSize="small" onClick={@forward}>
                        <LC.Icon size='2x' type="caret-right"  />
                    </BS.Button>
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
            <BS.Row className="flex-expand">
                <Skr.Screens.TimeTracking.PopoverEdit {...@state.edit} />
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
