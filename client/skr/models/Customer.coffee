class Skr.Models.Customer extends Skr.Models.Base


    props:
        id:                       {type:"integer"}
        code:                     {type:"code"}
        billing_address_id:       {type:"integer"}
        shipping_address_id:      {type:"integer"}
        terms_id:                 {type:"integer"}
        gl_receivables_account_id:{type:"integer", default: ->
            Skr.Models.GlAccount.default_ids.ar
        }
        credit_limit:             "bigdec"
        open_balance:             "bigdec"
        hash_code:                {type:"string"}
        name:                     {type:"string", required: true}
        notes:                    "string"
        website:                  "string"
        forms:                    "any"
        options:                  "any"

    mixins: ['HasCodeField']

    associations:
        billing_address:        { model: "Address" }
        shipping_address:       { model: "Address" }
        terms:                  { model: "PaymentTerm", required: true}
        gl_receivables_account: { model: "GlAccount", default: ->
            Skr.Models.GlAccount.fetchById(this.gl_receivables_account_id)
        }
        sales_orders:           { collection: "SalesOrder" }
        invoices:               { collection: "Invoice" }
