class Skr.Models.BankAccount extends Skr.Models.Base

    props:
        id:                 {type:"integer"}
        code:               {type:"code"}
        name:               {type:"string", "required":true}
        description:        {type:"string"}
        routing_number:     "string"
        account_number:     "string"
        address_id:         {type:"integer"}
        gl_account_id:      {type:"integer"}

    mixins: ['HasCodeField']

    associations:
        address:        { model: "Address" }
        gl_account: { model: "GlAccount", required: true }
