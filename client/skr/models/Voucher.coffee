class Skr.Models.Voucher extends Skr.Models.Base


    props:
        id:               {type:"integer"}
        visible_id:       {type:"visible_id"}
        vendor_id:        {type:"integer"}
        purchase_order_id:"integer"
        terms_id:         {type:"integer"}
        state:            {type:"string"}
        refno:            "string"
        confirmation_date:"any"

    mixins: [ 'HasVisibleId' ]

    associations:
        vendor:          { model: "Vendor" }
        customer:        { model: "Customer" }
        purchase_order:  { model: "PurchaseOrder" }
        terms:           { model: "PaymentTerm" }
        location:        { model: "Location" }
        gl_transactions: { collection: "GlTransaction" }
        lines:           { collection: "VoLine" }
