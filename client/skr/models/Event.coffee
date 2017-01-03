class Skr.Models.Event extends Skr.Models.Base

    props:
        id:                   {"type":"integer", "required":true}
        code:                 {"type":"string", "required":true}
        sku_id:               {"type":"integer", "required":true}
        title:                "string"
        sub_title:            "string"
        info:                 "string"
        venue:                "string"
        email_signature:      "string"
        post_purchase_message:"string"
        starts_at:            "date"
        max_qty:              "integer"

    mixins: [ 'FileSupport', 'HasCodeField' ]

    associations:
        photo:         { model: "Lanes.Models.Asset" }
        sku:           { model: "Sku", required: true }
        invoices:      { collection: "Invoice" }
        invoice_lines: { collection: "InvLine" }
