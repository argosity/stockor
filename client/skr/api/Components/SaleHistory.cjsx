class Skr.Api.Components.SaleHistory extends Skr.Api.Components.Base

    componentWillMount: ->
        @setState(orders: Skr.Api.Models.SalesHistory.get())

    render: ->
        return null if _.isEmpty( @state.orders )

        <table className="cart">
            <thead>
                <tr>
                    <th colSpan=3>Previous Purchases</th>
                </tr>
                <tr>
                    <th>Sale Number</th>
                    <th>Date</th>
                    <th>Amount</th>
                </tr>
            </thead>
            <tbody>
            {for order in @state.orders
                <tr>
                    <td>
                        <a target="_blank" href={order.pdfDownloadUrl()}>
                            {order.visible_id}
                        </a>
                    </td>
                    <td>{Lanes.u.format.shortDate(order.date)}</td>
                    <td>{Lanes.u.format.currency(order.total)}</td>
                </tr>}
            </tbody>
        </table>
