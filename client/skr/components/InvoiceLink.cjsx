class Skr.Components.InvoiceLink extends Lanes.React.Component
    propTypes:
        onClick: React.PropTypes.func
        invoice: React.PropTypes.instanceOf(Skr.Models.Invoice)

    onClick: ->
        @props.onClick?()
        @props.invoice.withAssociations(['lines']).then =>
            Lanes.Screens.Definitions.all.get('invoice')
                .display(props: {invoice: @props.invoice})

    render: ->
        <a href='#' onClick={@onClick}>{@props.invoice.visible_id}</a>
