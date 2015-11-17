class Skr.Models.PoReceipt extends Skr.Models.Base


    props:
        id:               {type:"integer"}
        visible_id:       {type:"integer"}
        location_id:      {type:"integer"}
        freight:          {type:"bigdec", "default":"0.0"}
        purchase_order_id:{type:"integer"}
        vendor_id:        {type:"integer"}
        voucher_id:       "integer"
        refno:            "string"

    associations:
        purchase_order: { model: "PurchaseOrder" }
        vendor:         { model: "Vendor" }
        location:       { model: "Location" }
        gl_transaction: { model: "GlTransaction" }
        lines:          { collection: "PorLine" }
