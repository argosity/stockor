class Skr.Models.IaLine extends Skr.Models.Base


    props:
        id:                     {type:"integer", required:true}
        inventory_adjustment_id:{type:"integer", required:true}
        sku_loc_id:             {type:"integer", required:true}
        qty:                    {type:"integer", required:true, "default":"1"}
        uom_code:               {type:"string", required:true, "default":"EA"}
        uom_size:               {type:"integer", required:true, "default":"1"}
        cost:                   "bigdec"
        cost_was_set:           {type:"boolean", required:true, default:false}

    associations:
        inventory_adjustment: { model: "InventoryAdjustment" }
        sku_loc:              { model: "SkuLoc" }
        sku:                  { model: "Sku" }
        sku_tran:             { model: "SkuTran" }
