class Skr.Api.OrderingComplete extends Skr.Api.Components.Base

    propTypes:
        options: React.PropTypes.shape(
            messages: React.PropTypes.object
        )

    getDefaultProps: ->
        options: {}

    modelBindings:
        sale: 'props'

    render: ->

        <div className="order-complete">
            <Skr.Api.Components.SaleHistory />
            <h3>Order number {@sale.visible_id} was successfully saved</h3>
            <a target='_blank' href={@sale.pdfDownloadUrl()}>
                {@props.options.messages?.receipt_download_message || 'Download Receipt'}
            </a>
            <div>
                <button onClick={@props.onComplete}>Place new order</button>
            </div>
        </div>
