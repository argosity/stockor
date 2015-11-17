class Skr.Models.IaReason extends Skr.Models.Base


    props:
        id:           {type:"integer"}
        gl_account_id:{type:"integer"}
        code:         {type:"string"}
        description:  {type:"string"}

    associations:
        gl_account: { model: "GlAccount" }
