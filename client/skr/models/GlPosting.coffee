class Skr.Models.GlPosting extends Skr.Models.Base


    props:
        id:               {type:"integer"}
        gl_transaction_id:{type:"integer"}
        account_number:   {type:"string"}
        amount:           {type:"bigdec"}
        is_debit:         {type:"boolean"}
        year:             {type:"integer"}
        period:           {type:"integer"}

    associations:
        gl_transaction: { model: "GlTransaction" }
