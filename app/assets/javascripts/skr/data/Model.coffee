class Skr.Data.Model extends Skr.Backbone.Model
    @api_path: ''

    Skr.lib.ModuleSupport.includeInto(this)

    @fetch: (options)->
        record = new this()
        if Skr.u.isNumber(options)
            record.id = options
            options = {}
        record.fetch(options)

    save: (options)->
        wrapResponse(this,options)
        if options.saveAll
            super(@attributes, options)
        else
            Skr.u.defaults( options, {patch: true})
            dirty = this.dirtyData()
            for association in this.associations
                if association.instance.isDirty()
                    dirty[association.name] = association.instance.dirtyData()
            super( dirty, options )

    dirtyData: ->
        Skr.u.pick( this.attributes, @unsavedAttributes... )

    isDirty: ->
        0 == @unsavedAttributes.length

    set: (key,val,options)->
        if typeof key == 'object'
            attrs = key;
            options = val;
        else
            (attrs = {})[key] = val
        options || (options = {});
        ret = super
        unless options.silent || options.ignoreUnsaved
            for name,val of attrs
                @unsavedAttributes.push( name ) if -1 == @unsavedAttributes.indexOf(name)
        ret

    parse:(resp)->
        if Skr.u.isArray(resp['data']) then resp['data'][0] else resp['data']

    fetch: (options={})->
        super(Skr.u.extend(options,{limit:1,ignoreUnsaved:true}))


    ensureAssociations: (names...,cb,scope)->
        needed = Skr.u.filter( @associations, (assoc)->
            Skr.u.contains(names, assoc.name) && ! assoc.instance.isLoaded()
        )
        if 0 == needed.length
            cb.call(scope||this, this )
            return this
        else
            this.fetch( include: Skr.u.pluck(needed,'name'), success: (rec)->
                cb.call(scope||rec, rec)
            )
            return this

    isLoaded: ->
        !Skr.u.isEmpty(this.attributes)

    constructor: () ->
        original_init = this.initialize;
        this.initialize = Skr.emptyFn
        this.unsavedAttributes=[]
        super
        this._setupAssociation(association) for association in ( @associations ||= [] )
        this.initialize=original_init;
        this.initialize.apply(this, arguments);
        this

    initialize: (attributes={}, options={})->
        @name ||= options.name || 'Model'
        super(attributes, options)

    urlBase: ->
        Skr.Data.Model.api_path + Skr.u.pluralize(@name.toLowerCase().replace(' ', '-'),0)

    url: ->
        base = this.urlBase()
        if @id then "#{base}/#{@id}.json"  else base + '.json'

    toggle: (attribute)->
        this.set( attribute, ! this.get(attribute) )

    _setupAssociation:(assoc)->
        klass = Skr.getObjectByName( assoc.model, 'Skr.Data')

        if ( instance = this.get(assoc.name ) ) and ( instance instanceof klass )
            this.attributes[ assoc.name ] = instance.attributes
        else
            instance = new klass( this.get(assoc.name), assoc.arguments )
        assoc.instance = instance
        instance.urlRoot = assoc.url if assoc.url
        instance[ if assoc.inverse_name then assoc.inverse_name else 'association' ] = this
        this[ assoc.name ] = instance

        this.on("change:#{assoc.name}", (ev,data,opts)->
            if Skr.u.isFunction( this.reset )
                this.reset(data)
            else
                this.set( if (data instanceof Model) then data.attributes else data )
        ,instance)



copyServerMessages=(model,msg)->
    return unless msg
    model.errors = msg.errors
    model.lastServerMessage = msg.message

wrapResponse = (model, options)->
    error   = options.error
    success = options.success
    options.error = (model,resp)->
        copyServerMessages(model,resp.responseJSON)
        error(arguments...) if error
    options.success = (model,resp)->
        model.unsavedAttributes = []
        copyServerMessages(model,resp.responseJSON)
        if ! options.success
            error(arguments...) if error
        else
            success(arguments...) if success
