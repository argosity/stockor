class Skr.Screens.TimeTracking.WeekSummary extends Lanes.React.BaseComponent

    color: (projectId) ->
        project = @props.entries.available_projects.get(projectId)
        project?.options?.color || 0

    render: ->
        order = (@props.week * 7) - 1
        totals = @props.entries.totalsForWeek(@props.week)

        <div className="day summary" style={order: order}>
            {for projectId, total of totals
                <div key={projectId} className="color-#{@color(projectId)}">
                    {Lanes.u.format.currency(total)}
                </div>}
        </div>
