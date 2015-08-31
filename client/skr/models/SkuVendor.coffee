class Skr.Models.SkuVendor extends Skr.Models.Base


    props:
        id:        {type:"integer", required:true}
        sku_id:    {type:"integer", required:true}
        vendor_id: {type:"integer", required:true}
        list_price:{type:"bigdec", required:true}
        part_code: {type:"string", required:true}
        is_active: {type:"boolean", required:true, default:true}
        uom_size:  {type:"integer", required:true, "default":"1"}
        uom_code:  {type:"string", required:true, "default":"EA"}
        cost:      {type:"bigdec", required:true}

    associations:
        sku:      { model: "Sku" }
        vendor:   { model: "Vendor" }
        sku_locs: { collection: "SkuLoc" }
