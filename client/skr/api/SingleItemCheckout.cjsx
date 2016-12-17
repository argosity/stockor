##= require '../components/CreditCardForm'
##= require './OrderingComplete'
##= require './OrderingForm'

class ErrorFetching extends Skr.Api.Components.Base

    render: ->
        <h1>Error loading sale item {@props.skuCode}</h1>


class Skr.Api.SingleItemCheckout extends Skr.Api.Components.Base

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

        Component = if @state.showingOrder then Skr.Api.OrderingForm else Skr.Api.OrderingComplete
        <div className="skr-simple-checkout">
            <Component
                options={@props.sale_options}
                skuCode={@props.skuCode}
                sale={@sale}
                cart={@cart}
                onComplete={@onTypeSwitch}
            />
        </div>
