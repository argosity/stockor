class Skr.Components.Currency extends Lanes.React.Component

    getDefaultProps: ->
        amount: _.bigDecimal('0.0')

    propTypes:
        amount: React.PropTypes.instanceOf(_.bigDecimal)

    render: ->
        <span className="currency">{@props.amount.toFixed(2)}</span>
