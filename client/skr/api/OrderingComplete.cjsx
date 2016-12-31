class Skr.Api.OrderingComplete extends Skr.Api.Components.Base

    propTypes:
        options: React.PropTypes.object

    getDefaultProps: ->
        options: {}

    modelBindings:
        sale: 'props'

    formName: ->
        _.pluralize(@props.options?.downloaded_form_name || 'Receipt',
            _.sumBy(@sale.lines, (l) -> l.qty)
        )

    render: ->
        <div className="order-complete">
            <h2 className="title">
                Order number {@sale.visible_id} was successfully saved
            </h2>
            <h4>{@props.options.post_purchase_message}</h4>
            <div className="controls section">
                <button onClick={@props.onComplete}>
                    Place new order
                </button>
                <a className="btn" target='_blank' href={@sale.pdfDownloadUrl()}>
                    Download {@formName()}
                </a>
            </div>
        </div>
