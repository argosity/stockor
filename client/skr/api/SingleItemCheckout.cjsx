##= require '../models/Sku'
##= require '../components/CreditCardForm'
##= require './OrderingComplete'
##= require './OrderingForm'

ErrorFetching = (props) ->
    <h1>Error loading sale item {props.skuCode}</h1>

Title = (props) ->
    return null unless props.text
    <h1>{props.text}</h1>

class Skr.Api.SingleItemCheckout extends Skr.Api.Components.Base

    statics:
        render: (options) ->
            new Lanes.React.Viewport(_.extend(options, {
                rootProps: options
                pubSubDisabled: true
                rootComponent: options.component || @
                useHistory: false
            }))

    propTypes:
        sku: Lanes.PropTypes.Model
        title: React.PropTypes.string

    getInitialState: ->
        showingOrder: true

    modelBindings:
        cart: -> @props.cart or new Skr.Api.Models.Cart
        sale: -> new Skr.Api.Models.Sale(@props.sale_options)

    componentWillMount: ->
        if @props.sku
            @cart.addSku(@props.sku)
        else if @props.skuCode
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
            <Title text={@props.sale_options?.title} />
            <Component
                options={@props.sale_options}
                skuCode={@props.skuCode}
                sale={@sale}
                cart={@cart}
                onComplete={@onTypeSwitch}
            />
        </div>
