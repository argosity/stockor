class Skr.Models.Sku extends Skr.Models.Base


    props:
        id:                  {type:"integer"}
        default_vendor_id:   {type:"integer"}
        gl_asset_account_id: {type:"integer", default: ->
            Skr.Models.GlAccount?.default_ids?.asset
        }
        default_uom_code:    {type:"string"}
        code:                {type:"code",   required:true}
        description:         {type:"string", required:true}
        is_public:           {type:"boolean", default:false}
        is_other_charge:     {type:"boolean", default:false}
        does_track_inventory:{type:"boolean", default:false}
        can_backorder:       {type:"boolean", default:false}

    session:
        price:               {type:"bigdec" }

    derived:
        display_price: deps: ['price'], fn: ->
            Lanes.u.format.currency @price

    mixins: ['HasCodeField']

    associations:
        default_vendor:   { model: "Vendor", required: true}
        gl_asset_account: { model: "GlAccount", required: true, default: ->
            Skr.Models.GlAccount?.all.get(this.gl_asset_account_id)
        }
        sku_locs:         { collection: "SkuLoc", required: true}
        sku_vendors:      { collection: "SkuVendor", required: true }
        uoms:             { collection: "Uom", inverse: 'sku' }
