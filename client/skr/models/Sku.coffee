class Skr.Models.Sku extends Skr.Models.Base


    props:
        id:                  {type:"integer", required:true}
        default_vendor_id:   {type:"integer", required:true}
        gl_asset_account_id: {type:"integer", required:true, default: ->
            Skr.Models.GlAccount.default_ids.asset
        }
        default_uom_code:    {type:"string", required:true}
        code:                {type:"code",   required:true}
        description:         {type:"string", required:true}
        is_other_charge:     {type:"boolean", required:true, default:false}
        does_track_inventory:{type:"boolean", required:true, default:false}
        can_backorder:       {type:"boolean", required:true, default:false}

    associations:
        default_vendor:   { model: "Vendor" }
        gl_asset_account: { model: "GlAccount", default: ->
            Skr.Models.GlAccount.fetchById(this.gl_asset_account_id)
        }
        sku_locs:         { collection: "SkuLoc" }
        sku_vendors:      { collection: "SkuVendor" }
        uoms:             { collection: "Uom", inverse: 'sku' }
