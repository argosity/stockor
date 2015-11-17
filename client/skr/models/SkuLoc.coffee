class Skr.Models.SkuLoc extends Skr.Models.Base


    props:
        id:           {type:"integer"}
        sku_id:       {type:"integer"}
        location_id:  {type:"integer"}
        mac:          {type:"bigdec", "default":"0.0"}
        qty:          {type:"integer", "default":"0"}
        qty_allocated:{type:"integer", "default":"0"}
        qty_picking:  {type:"integer", "default":"0"}
        qty_reserved: {type:"integer", "default":"0"}
        bin:          "string"
        sku_code:      {type:"string"}

    associations:
        sku:         { model: "Sku" }
        location:    { model: "Location" }
        so_lines:    { collection: "SoLine" }
        pt_lines:    { collection: "PtLine" }
        sku_vendors: { collection: "SkuVendor" }
