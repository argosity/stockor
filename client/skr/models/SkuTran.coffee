class Skr.Models.SkuTran extends Skr.Models.Base

    FILE: FILE

    props:
        id:                {"type":"integer","required":true}
        origin_id:         "integer"
        origin_type:       "string"
        sku_loc_id:        {"type":"integer","required":true}
        cost:              {"type":"bigdec","required":true}
        origin_description:{"type":"string","required":true}
        prior_qty:         {"type":"integer","required":true}
        mac:               {"type":"bigdec","required":true}
        prior_mac:         {"type":"bigdec","required":true}
        qty:               {"type":"integer","required":true,"default":"0"}
        uom_code:          {"type":"string","required":true,"default":"EA"}
        uom_size:          {"type":"integer","required":true,"default":"1"}

    associations:
        sku_loc:        { model: "SkuLoc" }
        location:       { model: "Location" }
        origin:         { model: "Origin" }
        gl_transaction: { model: "GlTransaction" }
