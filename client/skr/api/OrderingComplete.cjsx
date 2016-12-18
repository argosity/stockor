class Skr.Api.OrderingComplete extends Skr.Api.Components.Base

    propTypes:
        options: React.PropTypes.shape(
            messages: React.PropTypes.object
        )

    getDefaultProps: ->
        options: {}

    modelBindings:
        sale: 'props'

    formName: ->
        @props.options?.messages?.form_name || 'Receipt'

    render: ->
        <div className="order-complete">
            <h2 className="title">
                Order number {@sale.visible_id} was successfully saved
            </h2>
            <div className="controls section">
                <button onClick={@props.onComplete}>
                    Place new order
                </button>
                <a class="btn" target='_blank' className="btn" href={@sale.pdfDownloadUrl()}>
                    Download {@formName()}
                </a>
            </div>
        </div>
