class Skr.Models.SkuVendor extends Skr.Models.Base


    props:
        id:        {type:"integer"}
        sku_id:    {type:"integer"}
        vendor_id: {type:"integer"}
        list_price:{type:"bigdec"}
        part_code: {type:"string"}
        is_active: {type:"boolean", default:true}
        uom_size:  {type:"integer", "default":"1"}
        uom_code:  {type:"string", "default":"EA"}
        cost:      {type:"bigdec"}

    associations:
        sku:      { model: "Sku" }
        vendor:   { model: "Vendor" }
        sku_locs: { collection: "SkuLoc" }
