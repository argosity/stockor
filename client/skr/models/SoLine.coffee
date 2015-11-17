class Skr.Models.SoLine extends Skr.Models.Base

    mixins: [ Skr.Models.Mixins.SkuLine ]

    props:
        id:            {type:"integer"}
        sales_order_id:{type:"integer"}
        sku_loc_id:    {type:"integer"}
        price:         {type:"bigdec",  required:true}
        sku_code:      {type:"string",  required:true}
        description:   {type:"string",  required:true}
        uom_code:      {type:"string",  default: 'EA'}
        uom_size:      {type:"integer", default: 1}
        position:      {type:"integer"}
        qty:           {type:"integer", "default":"0"}
        qty_allocated: {type:"integer", "default":"0"}
        qty_picking:   {type:"integer", "default":"0"}
        qty_invoiced:  {type:"integer", "default":"0"}
        qty_canceled:  {type:"integer", "default":"0"}
        is_revised:    {type:"boolean", default:false}

    session:
        sku_id:     {type: 'integer'}

    associations:
        sales_order: { model: "SalesOrder"  }

    dataForSave: ->
        # so lines should never send associations
        super(excludeAssociations: true)
