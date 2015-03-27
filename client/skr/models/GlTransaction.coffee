class Skr.Models.GlTransaction extends Skr.Models.Base


    props:
        id:         {"type":"integer","required":true}
        period_id:  {"type":"integer","required":true}
        source_id:  "integer"
        source_type:"string"
        description:{"type":"string","required":true}

    associations:
        source:  { model: "Source" }
        period:  { model: "GlPeriod" }
        credits: { collection: "GlPosting" }
        debits:  { collection: "GlPosting" }
