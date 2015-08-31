class Skr.Models.GlPosting extends Skr.Models.Base


    props:
        id:               {type:"integer", required:true}
        gl_transaction_id:{type:"integer", required:true}
        account_number:   {type:"string", required:true}
        amount:           {type:"bigdec", required:true}
        is_debit:         {type:"boolean", required:true}
        year:             {type:"integer", required:true}
        period:           {type:"integer", required:true}

    associations:
        gl_transaction: { model: "GlTransaction" }
