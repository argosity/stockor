class Skr.Models.CreditCard extends Skr.Models.Base

    props:
        name:   {type: 'string', required: true}
        number: {type: 'string', required: true }
        month:  {type: 'integer', required: true }
        year:   {type: 'integer', required: true }
        cvc:    {type: 'integer', required: true }

    associations:
        payment: { model: "Payment", readOnly: true}

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
        @name ||= @payment.name if @payment.name
        @listenTo(@linkToAddress, 'change:name', @onAddressNameChange) if @linkToAddress

    onAddressNameChange: ->
        if !@name || @name is @linkToAddress.previous('name')
            @name = @linkToAddress.name

    onNameChange: ->
        @parent.name = @name

    onExpiryChange: ->
        [month, year] = @expiry.split(' / ')
        @month = month if month
        @year  = year  if year

    dataForSave: (options = {}) ->
        data = super
        # ActiveMerchant uses 'verification_value'
        data.verification_value = data.cvc
        data.year = 2000 + data.year
        delete data.cvc
        data
