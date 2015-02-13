class Skr.Models.IaReason extends Skr.Models.Base

    FILE: FILE

    props:
        id:           {"type":"integer","required":true}
        gl_account_id:{"type":"integer","required":true}
        code:         {"type":"string","required":true}
        description:  {"type":"string","required":true}

    associations:
        gl_account: { model: "GlAccount" }
