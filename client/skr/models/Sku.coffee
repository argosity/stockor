class Skr.Models.Sku extends Skr.Models.Base


    props:
        id:                  {"type":"integer","required":true}
        default_vendor_id:   {"type":"integer","required":true}
        gl_asset_account_id: {"type":"integer","required":true}
        default_uom_code:    {"type":"string","required":true}
        code:                {"type":"string","required":true}
        description:         {"type":"string","required":true}
        is_other_charge:     {"type":"boolean","required":true,"default":"false"}
        does_track_inventory:{"type":"boolean","required":true,"default":"false"}
        can_backorder:       {"type":"boolean","required":true,"default":"false"}

    associations:
        default_vendor:   { model: "Vendor" }
        gl_asset_account: { model: "GlAccount" }
        sku_locs:         { collection: "SkuLoc" }
        sku_vendors:      { collection: "SkuVendor" }
        uoms:             { collection: "Uom" }
