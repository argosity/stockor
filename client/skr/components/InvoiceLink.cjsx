class Skr.Components.InvoiceLink extends Lanes.React.Component
    propTypes:
        invoice: React.PropTypes.instanceOf(Skr.Models.Invoice)

    onClick: ->

        Lanes.Screens.Definitions.all.get('invoice')
            .display(invoice: @props.invoice)

    render: ->
        <a href='#' onClick={@onClick}>Invoice # {@props.invoice.visible_id}</a>