class Skr.Models.IaLine extends Skr.Models.Base


    props:
        id:                     {type:"integer"}
        inventory_adjustment_id:{type:"integer"}
        sku_loc_id:             {type:"integer"}
        qty:                    {type:"integer", "default":"1"}
        uom_code:               {type:"string", "default":"EA"}
        uom_size:               {type:"integer", "default":"1"}
        cost:                   "bigdec"
        cost_was_set:           {type:"boolean", default:false}

    associations:
        inventory_adjustment: { model: "InventoryAdjustment" }
        sku_loc:              { model: "SkuLoc", required: true}
        sku:                  { model: "Sku"}
        sku_tran:             { model: "SkuTran" }
