class Skr.Screens.Invoice.TotalExtraInfo extends Lanes.React.Component

    modelBindings:
        invoice: 'props'

    checkLoading: ->
        unless @invoice.total_hours
            @invoice.fetch({
                fields: ['total_hours']
            })

    TotalHours: ->
        body = if @invoice.total_hours
            <span>Hours: {Lanes.u.format.currency(@invoice.total_hours)}</span>
        else
            [
                <LC.Icon key="icon" type='spinner' />,
                <span key='msg'> Loading...</span>
            ]
        <div className="invoice-total-hours-tooltip">
            {body}
        </div>


    render: ->
        return null if @invoice.form isnt 'labor' or @invoice.isNew()

        <LC.Icon
            className='total-hours'
            tooltipProps={onEntering: @checkLoading}
            type='clock-o' tooltip={<@TotalHours />}
        />
