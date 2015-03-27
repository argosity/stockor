class Skr.Models.Location extends Skr.Models.Base


    props:
        id:            {"type":"integer","required":true}
        code:          {"type":"string","required":true}
        name:          {"type":"string","required":true}
        address_id:    {"type":"integer","required":true}
        is_active:     {"type":"boolean","required":true,"default":"true"}
        gl_branch_code:{"type":"string","required":true,"default":"01"}

    associations:
        address:  { model: "Address" }
        sku_locs: { collection: "SkuLoc" }
