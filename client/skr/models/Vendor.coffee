class Skr.Models.Vendor extends Skr.Models.Base


    props:
        id:                    {"type":"integer","required":true}
        billing_address_id:    {"type":"integer","required":true}
        shipping_address_id:   {"type":"integer","required":true}
        terms_id:              {"type":"integer","required":true}
        gl_payables_account_id:{"type":"integer","required":true}
        gl_freight_account_id: {"type":"integer","required":true}
        code:                  {"type":"string","required":true}
        hash_code:             {"type":"string","required":true}
        name:                  {"type":"string","required":true}
        notes:                 "string"
        account_code:          "string"
        website:               "string"

    associations:
        billing_address:     { model: "Address" }
        shipping_address:    { model: "Address" }
        terms:               { model: "PaymentTerm" }
        gl_payables_account: { model: "GlAccount" }
        gl_freight_account:  { model: "GlAccount" }
        purchase_orders:     { collection: "PurchaseOrder" }
        vouchers:            { collection: "Voucher" }
        vendor_skus:         { collection: "SkuVendor" }
        sku_vendors:         { collection: "SkuVendor" }
