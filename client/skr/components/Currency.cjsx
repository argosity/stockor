class Skr.Components.Currency extends Lanes.React.Component

    getDefaultProps: ->
        amount: _.bigDecimal('0.0')
        symbol: '$'

    propTypes:
        amount: React.PropTypes.instanceOf(_.bigDecimal)
        symbol: React.PropTypes.string

    render: ->
        className = _.classnames 'currency', @props.className
        <span {...@props} className={className}>
            {@props.symbol}
            {@props.amount.toFixed(2)}
        </span>
