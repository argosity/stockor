class Skr.Api.OrderingForm extends Skr.Api.Components.Base

    propTypes:
        skuCode: React.PropTypes.string
        options: React.PropTypes.shape(
            address_fields: React.PropTypes.shape(
                required: React.PropTypes.arrayOf(React.PropTypes.string)
                display:  React.PropTypes.arrayOf(React.PropTypes.string)
            )
        )

    modelBindings:
        sale: 'props'

    bindEvents:
        sale: "all"

    onPurchase: (ev) ->
        ev.preventDefault()
        @sale.copySkusFromCart(@props.cart)
        return unless @sale.validateBeforeSave()

        @setState(isSaving: true, isSaveComplete: false)
        @sale.save().then (a, b) =>
            @setState(isSaveComplete: true)
            _.delay =>
                @setState(isSaving: false)
                @props.onComplete() unless @sale.errors
            , 1100

    render: ->

        classNames = _.classnames( 'order', {
            'is-saving': @state.isSaving,
            'is-complete': @state.isSaveComplete
        })
        <div className={classNames}>
            <Skr.Api.Components.SaleHistory withSkuCode={@props.skuCode} />

            <div className="mask">
                <div className="msg">
                    <i /> <span>Submitting&#8230;</span>
                </div>
            </div>

            <div className="section">
                <Skr.Api.Components.SingleItemCart cart={@props.cart} />
            </div>

            <div className="section">
                <Skr.Api.Components.AddressForm
                    fields={@props.options.address_fields}
                    address={@sale.billing_address} />
            </div>
            <Skr.Components.CreditCardForm card={@sale.credit_card } />
            <div className={
                _.classnames('errors', visible: @sale.hasErrors)
            }>
                {@sale.errorMessage}
            </div>
            <div className="purchase">
                <button onClick={@onPurchase}>Purchase</button>
            </div>
        </div>
