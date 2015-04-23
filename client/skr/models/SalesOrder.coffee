class Skr.Models.SalesOrder extends Skr.Models.Base


    props:
        id:                 {"type":"integer","required":true}
        visible_id:         {"type":"integer","required":true}
        customer_id:        {"type":"integer","required":true}
        location_id:        {"type":"integer","required":true}
        shipping_address_id:{"type":"integer","required":true}
        billing_address_id: {"type":"integer","required":true}
        terms_id:           {"type":"integer","required":true}
        order_date:         {"type":"any","required":true}
        state:              {"type":"integer"}
        is_revised:         {"type":"boolean","required":true,"default":"false"}
        hash_code:          {"type":"string","required":true}
        ship_partial:       {"type":"boolean","required":true,"default":"false"}
        is_complete:        {"type":"boolean","required":true,"default":"false"}
        po_num:             "string"
        notes:              "string"
        options:            "any"

    enums:
        state:
            open: 1
            complete: 5
            canceled: 9

    associations:
        customer:         { model: "Customer" }
        location:         { model: "Location" }
        terms:            { model: "PaymentTerm" }
        billing_address:  { model: "Address" }
        shipping_address: { model: "Address" }
        lines:            { collection: "SoLine" }
        skus:             { collection: "Sku" }
        pick_tickets:     { collection: "PickTicket" }
        invoices:         { collection: "Invoice" }
