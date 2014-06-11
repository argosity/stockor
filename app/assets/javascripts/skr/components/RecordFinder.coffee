class FinderClause extends Skr.Component.Base

    template: 'record-finder-clause'

    attributes:
        class: "form-group clause"

    events:
        'hidden.bs.dropdown': 'onQueryChange'
        'click .del-clause': 'delClause'

    subViews:
        '.fields':{
            collection: 'fields', template:'<label><input type="radio" name="field"/> <span></span></label>'
            options:{
                 field: {selector: 'input', elAttribute: 'value'}
                 title: {selector: 'span'}
            }
        }
        '.operators':{
            collection: 'operators', template:'<label><input type="radio" name="operator"/> <span></span></label>'
            options:{
                id: {selector: 'input', elAttribute: 'value'}
                name: {selector: 'span'}
                invalid: Skr.View.fn.toggleClass('invalid')
            }
        }

    delClause: ->
        @model.collection.remove(@model)

    onQueryChange: ->
        this.$('input.query-string').focus()

    render: ->
        super
        @defer @focus, delay: 500
        this

    focus: ->
        this.$('input.query-string').focus()

    bindings:
        description: '.query-field-description'
        value: '.query-string'
        field: '.fields input[type=radio]'
        operator: '.operators input[type=radio]'

    initialize: (options)->
        super
        @fields = @model.fields
        @operators = @model.operators
        this

class FinderDialog extends Skr.Component.Modal
    events:
        'click .add-clause': 'addClause'
        'click .run-query':  'runQuery'
        'keyup .query-string': Skr.View.fn.onEnter('runQuery')
        'select': 'onSelect'

    subViews:
        '.grid':
            component: 'Grid'
            options: 'gridOptions'

        '.query-clauses':
            view: FinderClause, collection: 'clauses'

    bodyTemplate: 'record-finder-dialog'
    bodyAttributes:
        class: "record-finder"

    initialize:(options)->
        @query   = options.query
        @columns = options.columns
        @clauses = @query.clauses
        this.listenTo(@query.clauses,'add remove reset',this.setQueryClass)
        super

    onSelect: (ev, model)->
        @model = model
        @defer @close, delay: 200

    show:->
        super
        this

    setQueryClass: ->
        this.$('.query-clauses').toggleClass('multiple', (@query.clauses.length > 1))

    addClause: ->
        @query.addNewClause()

    gridOptions: ->
        { collection: 'collection', arguments: { columns: @columns } }

    runQuery: ->
        this.getSubView('.grid').setQuery(@query)


class Skr.Component.RecordFinder extends Skr.Component.Base

    template: 'record-finder'
    templateData: ->
        field: @query.defaultField().toJSON()

    events:
        "keyup .record-finder-query-string": Skr.View.fn.onEnter("runQuery")
        "click .record-finder-query": "displayFinder"

    initialize:(options)->
        @columns    = options.columns
        @query      = new Skr.Data.Query(@columns, collection:@collection)
        @title      = options.title

    displayFinder: ->
        finder = new FinderDialog( title: @title, columns: @columns, query: @query, collection: @collection )
        this.listenTo(finder,'hide', ->
            @$el.trigger("display-record",model) if model = finder.model
            finder.remove()
        )
        finder.show()

    runQuery: (ev)->
        code = this.$(ev.target).val()
        @query.loadSingle(code, (record)=>
            @$el.trigger("display-record",record)
        )
