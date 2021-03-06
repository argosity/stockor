class Skr.Models.PickTicket extends Skr.Models.Base


    props:
        id:            {type:"integer"}
        visible_id:    {type:"visible_id"}
        sales_order_id:{type:"integer"}
        location_id:   {type:"integer"}
        shipped_at:    "any"
        is_complete:   "boolean"

    mixins: [ 'HasVisibleId' ]

    associations:
        sales_order: { model: "SalesOrder" }
        invoice:     { model: "Invoice" }
        location:    { model: "Location" }
        customer:    { model: "Customer" }
        terms:       { model: "PaymentTerm" }
        lines:       { collection: "PtLine", inverse: 'pick_ticket' }
