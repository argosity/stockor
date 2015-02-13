class Skr.Models.Invoice extends Skr.Models.Base

    FILE: FILE

    props:
        id:                 {"type":"integer","required":true}
        visible_id:         {"type":"integer","required":true}
        terms_id:           {"type":"integer","required":true}
        customer_id:        {"type":"integer","required":true}
        location_id:        {"type":"integer","required":true}
        sales_order_id:     "integer"
        pick_ticket_id:     "integer"
        shipping_address_id:{"type":"integer","required":true}
        billing_address_id: {"type":"integer","required":true}
        amount_paid:        {"type":"bigdec","required":true,"default":"0.0"}
        state:              {"type":"string","required":true}
        hash_code:          {"type":"string","required":true}
        invoice_date:       {"type":"any","required":true}
        po_num:             "string"
        options:            "any"

    associations:
        sales_order:      { model: "SalesOrder" }
        customer:         { model: "Customer" }
        location:         { model: "Location" }
        terms:            { model: "PaymentTerm" }
        pick_ticket:      { model: "PickTicket" }
        billing_address:  { model: "Address" }
        shipping_address: { model: "Address" }
        gl_transactions:  { collection: "GlTransaction" }
        lines:            { collection: "InvLine" }
