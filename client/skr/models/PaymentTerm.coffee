SHARED_DATA = null
SHARED_COLLECTION = null

class Skr.Models.PaymentTerm extends Skr.Models.Base


    props:
        id:             {type:"integer"}
        code:           {type:"code"}
        days:           {type:"integer", "default":"0"}
        description:    {type:"string"}
        discount_days:  "integer"
        discount_amount:"string"

    @initialize: (data) ->
        SHARED_DATA = data.payment_terms


Object.defineProperty Skr.Models.PaymentTerm, 'all',
    get: ->
        SHARED_COLLECTION ||= new Skr.Models.PaymentTerm.Collection(
            SHARED_DATA, comparator: 'code'
        )
