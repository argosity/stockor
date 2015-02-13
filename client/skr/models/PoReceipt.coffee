class Skr.Models.PoReceipt extends Skr.Models.Base

    FILE: FILE

    props:
        id:               {"type":"integer","required":true}
        visible_id:       {"type":"integer","required":true}
        location_id:      {"type":"integer","required":true}
        freight:          {"type":"bigdec","required":true,"default":"0.0"}
        purchase_order_id:{"type":"integer","required":true}
        vendor_id:        {"type":"integer","required":true}
        voucher_id:       "integer"
        refno:            "string"

    associations:
        purchase_order: { model: "PurchaseOrder" }
        vendor:         { model: "Vendor" }
        location:       { model: "Location" }
        gl_transaction: { model: "GlTransaction" }
        lines:          { collection: "PorLine" }
