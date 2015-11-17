class Skr.Models.SkuTran extends Skr.Models.Base


    props:
        id:                {type:"integer"}
        origin_id:         "integer"
        origin_type:       "string"
        sku_loc_id:        {type:"integer"}
        cost:              {type:"bigdec"}
        origin_description:{type:"string"}
        prior_qty:         {type:"integer"}
        mac:               {type:"bigdec"}
        prior_mac:         {type:"bigdec"}
        qty:               {type:"integer", "default":"0"}
        uom_code:          {type:"string", "default":"EA"}
        uom_size:          {type:"integer", "default":"1"}

    associations:
        sku_loc:        { model: "SkuLoc" }
        location:       { model: "Location" }
        origin:         { model: "Origin" }
        gl_transaction: { model: "GlTransaction" }
