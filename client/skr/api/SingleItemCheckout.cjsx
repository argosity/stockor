##= require '../components/CreditCardForm'

class OrderingForm extends Skr.Api.Components.Base

    propTypes:
        skuCode: React.PropTypes.string
        address_fields: React.PropTypes.shape(
            required: React.PropTypes.arrayOf(React.PropTypes.string)
            display:  React.PropTypes.arrayOf(React.PropTypes.string)
        )

    modelBindings:
        sale: 'props'

    onPurchase: (ev) ->
        ev.preventDefault()
        @sale.copySkusFromCart(@props.cart)
        @setState(isSaving: true, isSaveComplete: false)
        @sale.save().then (a, b) =>
            @setState(isSaveComplete: true)
            _.delay =>
                @setState(isSaving: false)
                @setState(isSaveComplete: false)
                @props.onComplete() unless @sale.errors
            , 1100

    render: ->
        console.log @props
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

            {<div className="errors">{@sale.errorMessage}</div> if @sale.errorMessage}

            <div className="section">
                <Skr.Api.Components.AddressForm
                    fields={@props.address_fields}
                    address={@sale.billing_address} />
            </div>

            <Skr.Components.CreditCardForm card={@sale.credit_card } />
            <div className="purchase">
                <button onClick={@onPurchase}>Purchase</button>
            </div>
        </div>

class OrderingComplete extends Skr.Api.Components.Base

    modelBindings:
        sale: 'props'

    render: ->
        <div className="order-complete">
            <Skr.Api.Components.SaleHistory />
            <h3>Order number {@sale.visible_id} was successfully saved</h3>
            <a target='_blank' href={@sale.pdfDownloadUrl()}>Download Receipt</a>
            <div>
                <button onClick={@props.onComplete}>Place new order</button>
            </div>
        </div>


class ErrorFetching extends Skr.Api.Components.Base

    render: ->
        <h1>Error loading sale item {@props.skuCode}</h1>

class Skr.SingleItemCheckout extends Skr.Api.Components.Base

    statics:
        render: (options) ->
            new Lanes.React.Viewport(_.extend(options, {
                rootProps:
                    _.pick(options, 'sale_options', 'skuCode', 'customer')
                pubSubDisabled: true
                rootComponent: @
                useHistory: false
            }))

    getInitialState: ->
        showingOrder: true

    modelBindings:
        cart: -> new Skr.Api.Models.Cart
        sale: -> new Skr.Api.Models.Sale(@props.sale_options)

    componentWillMount: ->
        @cart.addBySkuCode(@props.skuCode).then =>
            @setState(errorFetching: true) if @cart.skus.length is 0

    onTypeSwitch: ->
        if @state.showingOrder
            Skr.Api.Models.SalesHistory.record(@sale)
        else
            @sale.clear()
        @setState(showingOrder: not @state.showingOrder)

    render: ->

        return <ErrorFetching skuCode={@props.skuCode} /> if @state.errorFetching

        Component = if @state.showingOrder then OrderingForm else OrderingComplete
        <div className="skr-simple-checkout">
            <Component
                address_fields={@props.sale_options?.address_fields}
                skuCode={@props.skuCode}
                sale={@sale}
                cart={@cart}
                onComplete={@onTypeSwitch}
            />
        </div>
