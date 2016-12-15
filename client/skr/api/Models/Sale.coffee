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
        form:        'string'
        options:     'object'

    session:
        address_fields: 'object'

    mixins: [ Lanes.Skr.Models.Mixins.PrintSupport ]

    associations:
        skus: { collection: SaleSku }
        billing_address: { model: 'Address', autoCreate: true }
        credit_card:
            model: 'Skr.Models.CreditCard', autoCreate: true
            options: ->
                linkToAddress: @billing_address

    printFormIdentifier: ->
        'invoice'

    copySkusFromCart: (cart) ->
        cart.skus.each (ci) =>
            @skus.add(sku_id: ci.sku.id, qty: ci.qty)

    save: ->
        super(with: 'details')

    validate: ->
        return true unless @address_fields?.require
        @errors = []
        if @address_fields
            for field in @address_fields.require
                @errors.push(field) unless @billing_address[field]
        if @errors.length is 0
            @error_message = ''
            return true

        @error_message = "The required field "
        @error_message += if @errors.length == 1
            "#{@errors[0]} is blank"
        else
            "s: #{_.toSentence(@errors)} are blank"
        false
