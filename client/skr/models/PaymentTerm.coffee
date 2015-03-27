class Skr.Models.PaymentTerm extends Skr.Models.Base


    props:
        id:             {"type":"integer","required":true}
        code:           {"type":"string","required":true}
        days:           {"type":"integer","required":true,"default":"0"}
        description:    {"type":"string","required":true}
        discount_days:  "integer"
        discount_amount:"string"
