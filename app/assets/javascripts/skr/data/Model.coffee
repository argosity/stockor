getObjectByName = ( name ) ->
    type = _.reduce( name.split( '.' ), ( ( memo, val )-> return memo[ val ] ),  window )
    if type != window then type else null


class Skr.Data.Model extends Skr.Backbone.Model
    @api_path: ''

    constructor: () ->
        original_init = this.initialize;
        this.initialize = Skr.emptyFn

        super
        parentModel = this

        for assoc in ( @associations ||= [] )
            klass = getObjectByName( assoc.model )

            if ( obj = this.get(assoc.associatedName ) ) and ( obj instanceof klass )
                this.attributes[ assoc.associatedName ] = obj.attributes
            else
                obj = new klass( this.get(assoc.associatedName), assoc.arguments )
            obj.urlRoot = assoc.url if assoc.url
            obj[ if assoc.inverse_name then assoc.inverse_name else 'association' ] = this
            this[ assoc.associatedName ] = obj

            parentModel.on("change:#{assoc.associatedName}", (ev,data,opts)->
                if _.isFunction( this.reset )
                    this.reset(data)
                else
                    this.set( if _.isObject(data) then data.attributes else data )
            ,obj)

        this.initialize=original_init;
        this.initialize.apply(this, arguments);
        this

    initialize: (attributes={}, options={})->
        @name = options.name || 'Model'
        @url  = @name.toLowerCase().replace(' ', '-')
        super(attributes, options)

    toggle: (attribute)->
        this.set( attribute, ! this.get(attribute) )
