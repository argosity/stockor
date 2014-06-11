class Field extends Skr.Backbone.Model

    constructor: (attributes)->
        super( Skr.u.defaults( attributes, {
            title: Skr.u.titleize(attributes.field)
        }))

class AvailableFields extends Skr.Backbone.Collection
    model: Field


class Operator extends Skr.Backbone.Model

    defaults:
        invalid: false

    setField:(field)->
        invalid =!!(this.get('type') && field.get('type') &&
            this.get('type') != field.get('type'))
        this.set({ invalid: invalid })

class Operators extends Skr.Backbone.Collection
    model: Operator

    constructor: ->
        super
        this.add([
            { id: 'like', name: 'Starts With', type:'s' }
            { id: 'eq',   name: 'Equals' }
            { id: 'lt',   name: 'Less Than',   type:'n' }
            { id: 'gt',   name: 'More Than',   type:'n' }
        ])
        this

class Clause extends Skr.Backbone.Model
    defaults:
        value: ''

    initialize:(attrs,options)->
        super
        @operators = new Operators
        @fields    = @collection.fields #.clone()
        this.on('change:field',this.setValidOperators,this)
        this.on('change', this.setDescription, this)
        this.setDescription()
        this

    setValidOperators:(model,field)->
        @operators.invoke('setField', @fields.findWhere(field:field) )
        if this.selectedOperator().get('invalid')
            op = this.operators.findWhere(invalid: false)
            this.set(operator: op.id)

    selectedOperator: ->
        this.operators.get( this.get('operator') )

    setDescription:->
        this.set( description: "#{Skr.u.titleize this.get('field')} #{this.get('operator')}" )

    isValid: ->
        this.get('value').length

    toParam: ->
        param = {}
        op = this.get('operator')
        value = this.get('value')
        value +='%' if 'like' == op
        param[ this.get('field') ] = if 'eq' == op then value else { op: op, value: value }
        param

class Clauses extends Skr.Backbone.Collection
    model: Clause

    initialize:(models,options)->
        super
        @fields = options.query.fields
        this

class Skr.Data.Query

    constructor: (fields,options={})->
        @fields = new AvailableFields(
            Skr.u.map( fields, (col)-> if Skr.u.isObject(col) then col else { field:col } )
        )
        @clauses      = new Clauses([], query: this )
        @initialField = options.initialField || fields[0].field
        @collection   = options.collection
        this.addNewClause()
        this

    loadSingle: (code,cb)->
        q = {}
        q[ @initialField ] = code
        @collection.prototype.model.fetch( query: q, success:cb )

    defaultField: ->
        @fields.findWhere( field: @initialField )

    asParams: ->
        params = {}
        @clauses.each (clause)->
            Skr.u.extend( params, clause.toParam() ) if clause.isValid()
        params

    addNewClause: ->
        @clauses.add({ field: @initialField, operator: 'like' })
