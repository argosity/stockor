class Skr.Models.PoLine extends Skr.Models.Base


    props:
        id:               {type:"integer", required:true}
        purchase_order_id:{type:"integer", required:true}
        sku_loc_id:       {type:"integer", required:true}
        sku_vendor_id:    {type:"integer", required:true}
        part_code:        {type:"string", required:true}
        sku_code:         {type:"string", required:true}
        description:      {type:"string", required:true}
        uom_code:         {type:"string", required:true}
        uom_size:         {type:"integer", required:true}
        position:         {type:"integer", required:true}
        qty:              {type:"integer", required:true, "default":"0"}
        qty_received:     {type:"integer", required:true, "default":"0"}
        qty_canceled:     {type:"integer", required:true, "default":"0"}
        price:            {type:"bigdec", required:true}
        is_revised:       {type:"boolean", required:true, default:false}

    associations:
        purchase_order: { model: "PurchaseOrder" }
        sku_loc:        { model: "SkuLoc" }
        sku_vendor:     { model: "SkuVendor" }
        sku:            { model: "Sku" }
        receipts:       { collection: "PorLine" }
