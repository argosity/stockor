class Skr.Models.PickTicket extends Skr.Models.Base


    props:
        id:            {type:"integer", required:true}
        visible_id:    {type:"integer", required:true}
        sales_order_id:{type:"integer", required:true}
        location_id:   {type:"integer", required:true}
        shipped_at:    "any"
        is_complete:   "boolean"

    associations:
        sales_order: { model: "SalesOrder" }
        invoice:     { model: "Invoice" }
        location:    { model: "Location" }
        customer:    { model: "Customer" }
        terms:       { model: "PaymentTerm" }
        lines:       { collection: "PtLine", inverse: 'pick_ticket' }
