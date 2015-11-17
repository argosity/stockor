class Skr.Models.PorLine extends Skr.Models.Base


    props:
        id:           {type:"integer"}
        po_receipt_id:{type:"integer"}
        po_line_id:   "integer"
        sku_loc_id:   {type:"integer"}
        sku_vendor_id:"integer"
        sku_code:     {type:"string"}
        part_code:    {type:"string"}
        description:  {type:"string"}
        uom_code:     {type:"string"}
        uom_size:     {type:"integer"}
        position:     {type:"integer"}
        qty:          {type:"integer", "default":"0"}
        price:        {type:"bigdec"}

    associations:
        po_receipt: { model: "PoReceipt" }
        sku_loc:    { model: "SkuLoc" }
        po_line:    { model: "PoLine" }
        sku_vendor: { model: "SkuVendor" }
        sku:        { model: "Sku" }
        sku_trans:  { collection: "SkuTran" }
