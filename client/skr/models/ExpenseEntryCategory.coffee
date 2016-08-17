class Skr.Models.ExpenseEntryCategory extends Skr.Models.Base

    props:
        id:          {"type":"any",     "required":true}
        entry_id:    {"type":"string",  "required":true}
        category_id: {"type":"integer", "required":true}
        amount:      {"type":"bigdec"}

    associations:
        category:   { model: "ExpenseCategory" }
        entry:      { model: "ExpenseEntry" }
