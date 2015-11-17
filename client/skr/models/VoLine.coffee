class Skr.Models.VoLine extends Skr.Models.Base


    props:
        id:           {type:"integer"}
        voucher_id:   {type:"integer"}
        sku_vendor_id:{type:"integer"}
        po_line_id:   "integer"
        sku_code:     {type:"string"}
        part_code:    {type:"string"}
        description:  {type:"string"}
        uom_code:     {type:"string"}
        uom_size:     {type:"integer"}
        position:     {type:"integer"}
        qty:          {type:"integer", "default":"0"}
        price:        {type:"bigdec"}

    associations:
        voucher:    { model: "Voucher" }
        sku_vendor: { model: "SkuVendor" }
        po_line:    { model: "PoLine" }
        sku:        { model: "Sku" }
