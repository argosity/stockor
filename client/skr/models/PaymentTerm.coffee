class Skr.Models.PaymentTerm extends Skr.Models.Base


    props:
        id:             {type:"integer"}
        code:           {type:"code"}
        days:           {type:"integer", "default":"0"}
        description:    {type:"string"}
        discount_days:  "integer"
        discount_amount:"string"
