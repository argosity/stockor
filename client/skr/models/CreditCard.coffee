class Skr.Models.CreditCard extends Skr.Models.Base

    props:
        name:   'string'
        number: 'string'
        month:  'integer'
        year:   'integer'
        cvc:    'integer'

    session:
        parent: 'object'
        expiry: 'string'
        linkToAddress: 'object'

    derived:
        cardType:
            deps: ['number'], fn: -> Skr.Vendor.Payment.fns.cardType(@number)
        cardIsValid:
            deps: ['name', 'number', 'month', 'year', 'cvc', 'cardType'], fn: ->
                v = Skr.Vendor.Payment.fns
                @name and _.trim(@name.length) > 2 and
                    @cardType and
                    v.validateCardNumber(@number) and
                    v.validateCardExpiry(@month, @year) and
                    v.validateCardCVC(@cvc, @cardType)


    events:
        'change:expiry': 'onExpiryChange'
        'change:name': 'onNameChange'

    initialize: ->
        @listenTo(@linkToAddress, 'change:name', @onAddressNameChange) if @linkToAddress

    onAddressNameChange: ->
        if @name is @linkToAddress.previousAttributes().name
            @name = @linkToAddress.name

    onNameChange: ->
        @parent.name = @name

    onExpiryChange: ->
        [@month, @year] = @expiry.split(' / ')

    dataForSave: (options = {}) ->
        attrs = super
        # ActiveMerchant uses 'verification_value'
        attrs.verification_value = attrs.cvc
        attrs
