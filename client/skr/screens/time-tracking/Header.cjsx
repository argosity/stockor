class Skr.Screens.TimeTracking.Header extends Lanes.React.BaseComponent

    back: ->
        @props.entries.back()
    forward: ->
        @props.entries.forward()
    changeDisplay: (ev) ->
        @props.entries.display = ev.target.value
    setProject: (project) ->
        @props.entries.set(customer_project_id: project.id)
    ProjectOption: (props) ->
        color = props.item.options?.color || 0
        <div className={"color-#{color}"}>{props.item.code}</div>
    getProjects: ->
        @props.entries.available_projects.models

    onProjectsToggle: (isOpen) ->
        if isOpen and not @props.entries.available_projects.requestInProgress
            @props.entries.available_projects.fetch()
            @forceUpdate()

    render: ->
        <BS.Row className='calendar-header'>

            <div className="paging">

                <span className="legend">
                    {@props.entries.calLegend}
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
                       active={@props.entries.display == 'month'}>Month</BS.Button>

                   <BS.Button
                       value='week' onClick={@changeDisplay}
                       active={@props.entries.display == 'week'}>Week</BS.Button>

                   <BS.Button
                       value='day' onClick={@changeDisplay}
                       active={@props.entries.display == 'day'}>Day</BS.Button>
                </BS.ButtonGroup>
            </div>

            <div className="select">
                <Lanes.Vendor.ReactWidgets.DropdownList
                    data={@getProjects()}
                    busy={!!@props.entries.available_projects.requestInProgress}
                    onToggle={@onProjectsToggle}
                    valueField='id' textField='code'
                    value={@props.entries.project}
                    onChange={@setProject}
                    valueComponent={@ProjectOption}
                    itemComponent={@ProjectOption}
                />
            </div>

        </BS.Row>
