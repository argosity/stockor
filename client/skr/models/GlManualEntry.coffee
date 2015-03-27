class Skr.Models.GlManualEntry extends Skr.Models.Base


    props:
        id:        {"type":"integer","required":true}
        visible_id:{"type":"integer","required":true}
        notes:     "string"

    associations:
        gl_transaction: { model: "GlTransaction" }
