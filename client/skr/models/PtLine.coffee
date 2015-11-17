class Skr.Models.PtLine extends Skr.Models.Base


    props:
        id:            {type:"integer"}
        pick_ticket_id:{type:"integer"}
        so_line_id:    {type:"integer"}
        sku_loc_id:    {type:"integer"}
        price:         {type:"bigdec"}
        sku_code:      {type:"string"}
        description:   {type:"string"}
        uom_code:      {type:"string"}
        bin:           "string"
        uom_size:      {type:"integer"}
        position:      {type:"integer"}
        qty:           {type:"integer", "default":"0"}
        qty_invoiced:  {type:"integer", "default":"0"}
        is_complete:   {type:"boolean", default:false}

    associations:
        pick_ticket: { model: "PickTicket" }
        sku_loc:     { model: "SkuLoc" }
        so_line:     { model: "SoLine" }
        inv_line:    { model: "InvLine" }
        sales_order: { model: "SalesOrder" }
        sku:         { model: "Sku" }
