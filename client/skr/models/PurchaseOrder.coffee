class Skr.Models.PurchaseOrder extends Skr.Models.Base


    props:
        id:                    {type:"integer"}
        visible_id:            {type:"integer"}
        vendor_id:             {type:"integer"}
        location_id:           {type:"integer"}
        ship_addr_id:          {type:"integer"}
        terms_id:              {type:"integer"}
        state:              {type:"integer"}
        is_revised:            {type:"boolean", default:false}
        order_date:            {type:"any"}
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
