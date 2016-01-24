class Skr.Models.GlManualEntry extends Skr.Models.Base


    props:
        id:        {type:"integer"}
        visible_id:{type:"visible_id"}
        notes:     "string"

    mixins: [ 'HasVisibleId' ]

    associations:
        gl_transaction: { model: "GlTransaction" }
