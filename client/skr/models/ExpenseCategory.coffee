class Skr.Models.ExpenseCategory extends Skr.Models.Base

    props:
        id:           {"type":"integer"}
        code:         {"type":"code",  "required":true}
        name:         {"type":"string", "required":true}
        is_active:    {"type":"boolean", "required":true, default: true}
        gl_account_id:{"type":"integer", "required":true}

    associations:
        gl_account: { model: "GlAccount" }
