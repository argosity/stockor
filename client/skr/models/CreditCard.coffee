class Skr.Api.Models.CreditCard extends Skr.Api.Models.Base

    props:
        name:   'string'
        number: 'string'
        month:  'integer'
        year:   'integer'
        cvc:    'integer'

    session:
        expiry: 'string'
        linkToAddress: 'object'

    derived:
        cardType:
            deps: ['number'], fn: -> Skr.Vendor.Payment.fns.cardType(@number)
        isValid:
            deps: ['name', 'number', 'month', 'year', 'cvc', 'cardType'], fn: ->
                v = Skr.Vendor.Payment.fns
                @name and _.trim(@name.length) > 2 and
                    @cardType and
                    v.validateCardNumber(@number) and
                    v.validateCardExpiry(@month, @year) and
                    v.validateCardCVC(@cvc, @cardType)


    events:
        'change:expiry': 'onExpiryChange'

    initialize: ->
        @listenTo(@linkToAddress, 'change:name', @onAddressNameChange) if @linkToAddress

    onAddressNameChange: ->
        if @name is @linkToAddress.previousAttributes().name
            @name = @linkToAddress.name

    onExpiryChange: ->
        [@month, @year] = @expiry.split(' / ')
