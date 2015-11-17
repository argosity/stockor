class Skr.Models.Vendor extends Skr.Models.Base


    props:
        id:                    {type:"integer"}
        billing_address_id:    {type:"integer"}
        shipping_address_id:   {type:"integer"}
        terms_id:              {type:"integer"}
        gl_payables_account_id:{type:"integer"}
        gl_freight_account_id: {type:"integer"}
        code:                  {type:"string"}
        hash_code:             {type:"string"}
        name:                  {type:"string"}
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
