##= require 'skr/models/Address'
##= require 'skr/models/CreditCard'

class SaleSku extends Lanes.Models.State

    props:
        sku_id: 'integer'
        qty:     'integer'

class Skr.Api.Models.Sale extends Skr.Api.Models.Base

    props:
        address_id:  'integer'
        id:          'integer'
        visible_id:  'visible_id'
        terms_id:    'integer'
        customer_id: 'integer'
        hash_code:   'string'
        total:       'bigdec'
        options:     'object'

    session:
        address_fields: 'object'
        lines: 'array'

    mixins: [ Lanes.Skr.Models.Mixins.PrintSupport ]

    associations:
        skus: { collection: SaleSku }
        billing_address: { model: 'Address', required: true }
        credit_card:
            model: 'Skr.Models.CreditCard', required: true
            options: ->
                linkToAddress: @billing_address

    printFormIdentifier: ->
        'invoice'

    copySkusFromCart: (cart) ->
        @skus.reset()
        cart.skus.each (ci) =>
            @skus.add(sku_id: ci.sku.id, qty: ci.qty)

    save: ->
        super(with: 'details', include:'lines')

    validateBeforeSave: ->
        @billing_address.unmaskInvalidField('all')
        @credit_card.unmaskInvalidField('all')
        return true if @billing_address.isSavable and @credit_card.isSavable

        errors = {}
        for attr in @billing_address.invalidAttributes
            errors["address_#{attr}"] = "is not valid"
        for attr in @credit_card.invalidAttributes
            errors["card #{attr}"] = 'is not valid'

        @errors = errors

        return @errors.length is 0
