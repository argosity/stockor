class Skr.Models.VoLine extends Skr.Models.Base

    FILE: FILE

    props:
        id:           {"type":"integer","required":true}
        voucher_id:   {"type":"integer","required":true}
        sku_vendor_id:{"type":"integer","required":true}
        po_line_id:   "integer"
        sku_code:     {"type":"string","required":true}
        part_code:    {"type":"string","required":true}
        description:  {"type":"string","required":true}
        uom_code:     {"type":"string","required":true}
        uom_size:     {"type":"integer","required":true}
        position:     {"type":"integer","required":true}
        qty:          {"type":"integer","required":true,"default":"0"}
        price:        {"type":"bigdec","required":true}

    associations:
        voucher:    { model: "Voucher" }
        sku_vendor: { model: "SkuVendor" }
        po_line:    { model: "PoLine" }
        sku:        { model: "Sku" }
