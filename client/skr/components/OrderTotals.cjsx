class Skr.Components.OrderTotals extends Lanes.React.Component

    propTypes:
        model: Lanes.PropTypes.Model.isRequired

    render: ->
        <BS.Row className='order-total'>
            <BS.Col md=10 className="text-right">
                Total:
            </BS.Col>
            <BS.Col md=2>
                <Skr.Components.Currency amount={@model.total} />
            </BS.Col>
        </BS.Row>
