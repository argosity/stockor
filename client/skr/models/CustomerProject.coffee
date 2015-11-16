class Skr.Models.CustomerProject extends Skr.Models.Base

    props:
        id:         {"type":"integer" }
        code:       {"type":"code"    }
        description:{"type":"string"  }
        po_num:     {"type":"string"  }
        sku_id:     {"type":"integer" }
        customer_id:{"type":"integer" }
        rates:      "any"

    session:
        sku_code:       {type:"string"}
        customer_code:  {type:"string"}

    associations:
        customer: { model: "Customer" }
        sku:      { model: "Sku" }
        time_entries:  { collection: 'TimeEntry', inverse: 'customer_project' }
