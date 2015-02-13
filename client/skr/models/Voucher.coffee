class Skr.Models.Voucher extends Skr.Models.Base

    FILE: FILE

    props:
        id:               {"type":"integer","required":true}
        visible_id:       {"type":"integer","required":true}
        vendor_id:        {"type":"integer","required":true}
        purchase_order_id:"integer"
        terms_id:         {"type":"integer","required":true}
        state:            {"type":"string","required":true}
        refno:            "string"
        confirmation_date:"any"

    associations:
        vendor:          { model: "Vendor" }
        customer:        { model: "Customer" }
        purchase_order:  { model: "PurchaseOrder" }
        terms:           { model: "PaymentTerm" }
        location:        { model: "Location" }
        gl_transactions: { collection: "GlTransaction" }
        lines:           { collection: "VoLine" }
