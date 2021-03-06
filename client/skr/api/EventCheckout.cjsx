##= require '../models/Event'
##= require '../models/Sku'
##= require 'lanes/components/shared/NetworkActivityOverlay'
##= require './OrderingComplete'
##= require './OrderingForm'

ErrorFetching = (props) ->
    <h1>Error loading event {props.eventCode}</h1>

class Skr.Api.EventCheckout extends Skr.Api.Components.Base

    statics:
        render: (options) ->
            Skr.Api.SingleItemCheckout.render(
                _.extend(options, component: @)
            )

    modelBindings:
        cart:  -> new Skr.Api.Models.Cart
        event: ->
            event = new Skr.Models.Event(code: @props.eventCode)
            _.extend(event, Skr.Api.Models.PublicApiPath)
            event


    componentWillMount: ->
        @event.fetch(query: {code: @event.code}).then =>
            if @event.isNew()
                @setState(errorFetching: true)
            else
                @cart.addSku(@event.sku)

    getSaleOptions: ->
        _.extend({},
            _.pick(@event.toJSON(), 'title', 'sub_title', 'post_purchase_message'),
            { downloaded_form_name: 'Ticket', event_id: @event.id },
            @props.sale_options
        )

    render: ->
        return <ErrorFetching {...@props} /> if @state.errorFetching

        <div>
            <Lanes.Components.NetworkActivityOverlay model={@event} />
            <Skr.Api.SingleItemCheckout
                sale_options={@getSaleOptions()}
                cart={@cart}
            />
        </div>
