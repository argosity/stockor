class Skr.Models.Customer extends Skr.Models.Base


    props:
        id:                       {"type":"integer","required":true}
        code:                     {"type":"code","required":true}
        billing_address_id:       {"type":"integer","required":true}
        shipping_address_id:      {"type":"integer","required":true}
        terms_id:                 {"type":"integer","required":true}
        gl_receivables_account_id:{"type":"integer","required":true}
        credit_limit:             "bigdec"
        open_balance:             "bigdec"
        hash_code:                {"type":"string","required":true}
        name:                     {"type":"string","required":true}
        notes:                    "string"
        website:                  "string"
        options:                  "any"

    associations:
        billing_address:        { model: "Address" }
        shipping_address:       { model: "Address" }
        terms:                  { model: "PaymentTerm" }
        gl_receivables_account: { model: "GlAccount" }
        sales_orders:           { collection: "SalesOrder" }
        invoices:               { collection: "Invoice" }
