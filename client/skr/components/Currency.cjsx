class Skr.Components.Currency extends Lanes.React.Component

    getDefaultProps: ->
        amount: _.bigDecimal('0.0')
        symbol: '$'

    propTypes:
        amount: React.PropTypes.oneOfType([
            React.PropTypes.number,
            React.PropTypes.instanceOf(_.bigDecimal)
        ])
        symbol: React.PropTypes.string

    render: ->
        className = _.classnames 'currency', @props.className
        <span {...@props} className={className}>
            <span className="sym">{@props.symbol}</span>
            {@props.amount.toFixed(2)}
        </span>
