class Skr.Models.InventoryAdjustment extends Skr.Models.Base

    FILE: FILE

    props:
        id:         {"type":"integer","required":true}
        visible_id: {"type":"integer","required":true}
        location_id:{"type":"integer","required":true}
        reason_id:  {"type":"integer","required":true}
        state:      {"type":"string","required":true}
        description:{"type":"string","required":true}

    associations:
        gl_transaction: { model: "GlTransaction" }
        location:       { model: "Location" }
        reason:         { model: "IaReason" }
        lines:          { collection: "IaLine" }
