class Skr.Models.PurchaseOrder extends Skr.Models.Base


    props:
        id:                    {type:"integer", required:true}
        visible_id:            {type:"integer", required:true}
        vendor_id:             {type:"integer", required:true}
        location_id:           {type:"integer", required:true}
        ship_addr_id:          {type:"integer", required:true}
        terms_id:              {type:"integer", required:true}
        state:              {type:"integer"}
        is_revised:            {type:"boolean", required:true, default:false}
        order_date:            {type:"any", required:true}
        receiving_completed_at:"date"

    enums:
        state:
            open: 1
            received: 2

    associations:
        terms:     { model: "PaymentTerm" }
        vendor:    { model: "Vendor" }
        location:  { model: "Location" }
        ship_addr: { model: "Address" }
        lines:     { collection: "PoLine" }
        receipts:  { collection: "PoReceipt" }
