class CartSku extends Lanes.Models.State

    session:
        sku: 'state'
        qty:  type: 'integer', default: 0, required: true

    derived:
        total: deps: ['qty', 'sku.price'], fn: ->
            @sku.price?.times(@qty) or 0
        display_total:
            deps: ['total'], fn: ->
                Lanes.u.format.currency @total

class Skr.Api.Models.Cart extends Skr.Api.Models.Base

    session:
        total:
            type: 'bigdec', required: true, default: -> _.bigDecimal('0')

    derived:
        display_total:
            deps: ['total'], fn: ->
                Lanes.u.format.currency @total

    associations:
        skus: { collection: CartSku }

    addSku: (sku, qty = 1) ->
        ci = new CartSku({sku, qty})
        @skus.add(ci)

    initialize: ->
        @listenToAndRun(@skus, 'add change', @onSkusChange)

    onSkusChange: ->
        @total = _.sumBy(@skus.models, 'total') unless @skus.isEmpty()

    addBySkuCode: (code) ->
        sku = new Skr.Models.Sku({code})
        sku.fetch(query: {code}).then (sku) =>
            @addSku(sku) unless sku.isNew()
