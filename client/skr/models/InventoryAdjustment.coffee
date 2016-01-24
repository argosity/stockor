class Skr.Models.InventoryAdjustment extends Skr.Models.Base


    props:
        id:         {type:"integer"}
        visible_id: {type:"visible_id"}
        location_id:{type:"integer"}
        reason_id:  {type:"integer"}
        state:      {type:"string"}
        description:{type:"string"}

    mixins: [ 'HasVisibleId' ]

    associations:
        gl_transaction: { model: "GlTransaction" }
        location:       { model: "Location" }
        reason:         { model: "IaReason" }
        lines:          { collection: "IaLine" }
