class Skr.Models.CreditCardGateway extends Skr.Models.Base

    registerForPubSub: false

    props:
        login:    "string"
        password: "string"
        type:     "string"

    modelTypeIdentifier: -> 'credit-card-gateway'

    @allTypes: ->
        [
            {id: 'authorize_net_gateway',    name: 'AuthorizeNet' }
            {id: 'balanced_gateway',         name: 'Balanced' }
            {id: 'card_stream_gateway',      name: 'Card Stream' }
            {id: 'first_pay_gateway',        name: 'FirstPay' }
            {id: 'global_transport_gateway', name: 'GlobalTransport' }
            {id: 'link_point_gateway',       name: 'Linkpoint' }
            {id: 'paypal_express_gateway',   name: 'Paypal Express' }
            {id: 'paypal_gateway',           name: 'Paypal' }
            {id: 'sage_gateway',             name: 'Sage' }
            {id: 'sage_pay_gateway',         name: 'SagePay' }
            {id: 'secure_net_gateway',       name: 'Secure Net' }
            {id: 'secure_pay_gateway',       name: 'Secure Pay' }
            {id: 'stripe_gateway',           name: 'Stripe' }
        ]
