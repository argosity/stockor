class Skr.Models.ExpenseEntry extends Skr.Models.Base

    props:
        id:                  {type:"integer"}
        uuid:                {"type":"string"}
        name:                {"type":"string", "required":true}
        occured:             {"type":"date", "required":true}
        gl_transaction_id:    "integer"
        memo:                 "string"
        expense_category_id: {"type":"integer", "required":true}

    session:
        category_total:       type:"bigdec", "required":true
        category_list:        type: "object"
        gl_transaction_ids:   type: 'array'
        category_ids:         type: 'array'

    associations:
        categories:       { collection: "ExpenseEntryCategory", inverse: 'entry' }
        gl_transaction:   { model: "GlTransaction"   }

    dataForSave: ->
        super(includeAssociations: [
            'categories'
        ])

    total: ->
        @categories.reduce (amt, cat) ->
            cat.amount.add(amt)
        , _.bigDecimal('0')
