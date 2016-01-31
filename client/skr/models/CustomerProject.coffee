class Skr.Models.CustomerProject extends Skr.Models.Base

    @COLORS: _.map([
        'gray', 'blue', 'orange', 'green', 'pink',
        'brown', 'purple', 'yellow' , 'red', 'tan'
    ], (v, i) -> {id: i + 1, name: v})

    props:
        id:           {"type":"integer" }
        code:         {"type":"code"    }
        name:         {"type":"string"  }
        description:  {"type":"string"  }
        po_num:       {"type":"string"  }
        invoice_form: {"type":"string"  }
        sku_id:       {"type":"integer" }
        customer_id:  {"type":"integer" }
        options:    "any"
        rates:      "any"

    mixins: ['HasCodeField']

    session:
        sku_code:       {type:"string"}
        customer_code:  {type:"string"}

    associations:
        customer: { model: "Customer" }
        sku:      { model: "Sku" }
        time_entries:  { collection: 'TimeEntry', inverse: 'customer_project' }
