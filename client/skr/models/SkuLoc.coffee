class Skr.Models.SkuLoc extends Skr.Models.Base

    FILE: FILE

    props:
        id:           {"type":"integer","required":true}
        sku_id:       {"type":"integer","required":true}
        location_id:  {"type":"integer","required":true}
        mac:          {"type":"bigdec","required":true,"default":"0.0"}
        qty:          {"type":"integer","required":true,"default":"0"}
        qty_allocated:{"type":"integer","required":true,"default":"0"}
        qty_picking:  {"type":"integer","required":true,"default":"0"}
        qty_reserved: {"type":"integer","required":true,"default":"0"}
        bin:          "string"

    associations:
        sku:         { model: "Sku" }
        location:    { model: "Location" }
        so_lines:    { collection: "SoLine" }
        pt_lines:    { collection: "PtLine" }
        sku_vendors: { collection: "SkuVendor" }
