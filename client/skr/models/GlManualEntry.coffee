class Skr.Models.GlManualEntry extends Skr.Models.Base


    props:
        id:        {type:"integer"}
        visible_id:{type:"integer"}
        notes:     "string"

    associations:
        gl_transaction: { model: "GlTransaction" }
