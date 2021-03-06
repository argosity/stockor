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
        colProps = _.omit(@props,  _.keys(@constructor.propTypes))
        className = _.classnames 'currency', @props.className
        <span {...colProps} className={className}>
            <span className="sym">{@props.symbol}</span>
            {Lanes.u.format.currency(@props.amount)}
        </span>
