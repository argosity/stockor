class Skr.Models.PoLine extends Skr.Models.Base


    props:
        id:               {type:"integer"}
        purchase_order_id:{type:"integer"}
        sku_loc_id:       {type:"integer"}
        sku_vendor_id:    {type:"integer"}
        part_code:        {type:"string"}
        sku_code:         {type:"string"}
        description:      {type:"string"}
        uom_code:         {type:"string"}
        uom_size:         {type:"integer"}
        position:         {type:"integer"}
        qty:              {type:"integer", "default":"0"}
        qty_received:     {type:"integer", "default":"0"}
        qty_canceled:     {type:"integer", "default":"0"}
        price:            {type:"bigdec"}
        is_revised:       {type:"boolean", default:false}

    associations:
        purchase_order: { model: "PurchaseOrder" }
        sku_loc:        { model: "SkuLoc" }
        sku_vendor:     { model: "SkuVendor" }
        sku:            { model: "Sku" }
        receipts:       { collection: "PorLine" }
