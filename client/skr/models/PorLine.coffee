class Skr.Models.PorLine extends Skr.Models.Base


    props:
        id:           {"type":"integer","required":true}
        po_receipt_id:{"type":"integer","required":true}
        po_line_id:   "integer"
        sku_loc_id:   {"type":"integer","required":true}
        sku_vendor_id:"integer"
        sku_code:     {"type":"string","required":true}
        part_code:    {"type":"string","required":true}
        description:  {"type":"string","required":true}
        uom_code:     {"type":"string","required":true}
        uom_size:     {"type":"integer","required":true}
        position:     {"type":"integer","required":true}
        qty:          {"type":"integer","required":true,"default":"0"}
        price:        {"type":"bigdec","required":true}

    associations:
        po_receipt: { model: "PoReceipt" }
        sku_loc:    { model: "SkuLoc" }
        po_line:    { model: "PoLine" }
        sku_vendor: { model: "SkuVendor" }
        sku:        { model: "Sku" }
        sku_trans:  { collection: "SkuTran" }
