class Skr.Models.SoLine extends Skr.Models.Base


    props:
        id:            {"type":"integer","required":true}
        sales_order_id:{"type":"integer","required":true}
        sku_loc_id:    {"type":"integer","required":true}
        price:         {"type":"bigdec","required":true}
        sku_code:      {"type":"string","required":true}
        description:   {"type":"string","required":true}
        uom_code:      {"type":"string","required":true}
        uom_size:      {"type":"integer","required":true}
        position:      {"type":"integer","required":true}
        qty:           {"type":"integer","required":true,"default":"0"}
        qty_allocated: {"type":"integer","required":true,"default":"0"}
        qty_picking:   {"type":"integer","required":true,"default":"0"}
        qty_invoiced:  {"type":"integer","required":true,"default":"0"}
        qty_canceled:  {"type":"integer","required":true,"default":"0"}
        is_revised:    {"type":"boolean","required":true,"default":"false"}

    associations:
        sales_order: { model: "SalesOrder" }
        sku_loc:     { model: "SkuLoc" }
        sku:         { model: "Sku" }
        location:    { model: "Location" }
        pt_lines:    { collection: "PtLine" }
