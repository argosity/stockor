class Skr.Models.GlTransaction extends Skr.Models.Base


    props:
        id:         {type:"integer"}
        period_id:  {type:"integer"}
        source_id:  "integer"
        source_type:"string"
        description:{type:"string"}

    associations:
        source:  { model: "Source" }
        period:  { model: "GlPeriod" }
        credits: { collection: "GlPosting" }
        debits:  { collection: "GlPosting" }
