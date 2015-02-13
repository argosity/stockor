class Skr.Models.PtLine extends Skr.Models.Base

    FILE: FILE

    props:
        id:            {"type":"integer","required":true}
        pick_ticket_id:{"type":"integer","required":true}
        so_line_id:    {"type":"integer","required":true}
        sku_loc_id:    {"type":"integer","required":true}
        price:         {"type":"bigdec","required":true}
        sku_code:      {"type":"string","required":true}
        description:   {"type":"string","required":true}
        uom_code:      {"type":"string","required":true}
        bin:           "string"
        uom_size:      {"type":"integer","required":true}
        position:      {"type":"integer","required":true}
        qty:           {"type":"integer","required":true,"default":"0"}
        qty_invoiced:  {"type":"integer","required":true,"default":"0"}
        is_complete:   {"type":"boolean","required":true,"default":"false"}

    associations:
        pick_ticket: { model: "PickTicket" }
        sku_loc:     { model: "SkuLoc" }
        so_line:     { model: "SoLine" }
        inv_line:    { model: "InvLine" }
        sales_order: { model: "SalesOrder" }
        sku:         { model: "Sku" }
