class Skr.Models.SoLine extends Skr.Models.Base

    mixins: [ Skr.Models.Mixins.SkuLine ]

    props:
        id:            {type:"integer", required:true}
        sales_order_id:{type:"integer"}
        sku_loc_id:    {type:"integer", required:true}
        price:         {type:"bigdec",  required:true}
        sku_code:      {type:"string",  required:true}
        description:   {type:"string",  required:true}
        uom_code:      {type:"string",  default: 'EA'}
        uom_size:      {type:"integer", default: 1}
        position:      {type:"integer", required:true}
        qty:           {type:"integer", required:true, "default":"0"}
        qty_allocated: {type:"integer", required:true, "default":"0"}
        qty_picking:   {type:"integer", required:true, "default":"0"}
        qty_invoiced:  {type:"integer", required:true, "default":"0"}
        qty_canceled:  {type:"integer", required:true, "default":"0"}
        is_revised:    {type:"boolean", required:true, default:false}

    session:
        sku_id:     {type: 'integer'}

    associations:
        sales_order: { model: "SalesOrder"  }

    dataForSave: ->
        # so lines should never send associations
        super(excludeAssociations: true)
