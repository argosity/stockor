class ExpenseAssets extends Lanes.Models.AssociationCollection


    comparator: (a) -> ! a.isPresent

    constructor: ->
        super
        @listenTo(@parent, 'save', @onSave)
        @on('change:length', @ensureBlank)
        @on('change:isPresent', @ensureBlank)
        @ensureBlank()
        @present = @subcollection(watched: ['isPresent'], filter: (m) ->
            m.isPresent
        )


    getId: -> @parent.getId()
    modelTypeIdentifier: -> @parent.modelTypeIdentifier()
    extensionIdentifier: -> @parent.extensionIdentifier()

    ensureBlank: ->
        blank = @find( (asset) -> !asset.isPresent )
        @add({}) unless blank

    onSave: ->
        @each (asset) -> asset.save()

    _prepareModel: (attrs, options) ->
        attrs.parent || = @
        attrs.parent_association = @options.association_name
        super


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
        attachments:      { collection: "Lanes.Models.Asset", options: { 'collectionClass': ExpenseAssets } }

    dataForSave: ->
        super(includeAssociations: [
            'categories'
        ])

    total: ->
        @categories.reduce (amt, cat) ->
            cat.amount.add(amt)
        , _.bigDecimal('0')
