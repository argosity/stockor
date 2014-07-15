
class DataModel

    constructor: ->
        Skr.Ampersand.Model.apply(this, arguments)


    api_path: ->
        Skr.u.pluralize(@title.toLowerCase().replace(' ', '-'),0)

    urlRoot: ->
        Skr.Data.Model.api_path + @resultsFor('api_path')

    setupStandardProps: -> Skr.emptyFn

    isLoaded: ->
        !Skr.u.isEmpty(this.attributes)

    ensureAssociations: (names...,cb,scope)->
        needed = Skr.u.filter( @_associations, (assoc)->
            Skr.u.contains(names, assoc.name) && ! assoc.instance(this).isLoaded()
        , this)
        if Skr.u.isEmpty( needed )
            cb.call(scope||this, this )
            return this
        else
            this.fetch( include: Skr.u.pluck(needed,'name'), success: (rec)->
                cb.call(scope||rec, rec)
            )
            return this

    @fetch: (options)->
        record = new this()
        if Skr.u.isNumber(options)
            record.id = options
            options = {}
        record.fetch(options)

    fetch: (options={})->
        super(Skr.u.extend(options,{limit:1,ignoreUnsaved:true}))

    parse:(resp)->
        if Skr.u.isArray(resp['data']) then resp['data'][0] else resp['data']

    associationDefinitions: ->
        for id, definition of ( @associations || {} )
                fk: id
                name: id.replace(/_id$/,'')
                klass: definition
                type: 'belongsTo'
                instance: (parent)-> parent[@name]


    sync: ->
        Skr.Data.Sync.apply(this,arguments)

    @extended: (klass)->
        if Skr.u.isUndefined(klass.Collection)
            klass.Collection = createAutoCollection(klass)
        klass.prototype.props   ||= {}
        klass.prototype.session ||= {}

        (klass.prototype.addStandardProperties || setupStandardProps).call(klass, klass.prototype)
        if klass.prototype.props_schema
            setProps(klass.prototype.props, klass.prototype.props_schema)

        if klass.prototype.session_schema
            setProps(klass.prototype.session, klass.prototype.session_schema)
        definitions = ( this.prototype.associationDefinitions || klass.prototype.associationDefinitions ).call(klass.prototype)
        setupAssociations( klass.prototype, definitions ) unless Skr.u.isEmpty( definitions )


    set: (key,value,options)->
        super
        if @_associations
            if (Skr.u.isObject(key) || key == null)
                attrs = key;
                options = value;
            else
                attrs = {};
                attrs[key] = value;
            for association in @_associations
                association.instance(this).set(attrs[association.name]) if attrs[association.name]
        this



    Skr.lib.ModuleSupport.includeInto(@)
    @include Skr.lib.results




associationDerivedDefinition = (definition)->
    klass = Skr.getObjectByName(definition.klass)
    {
        deps: [definition.fk]
        fn: ->
            args = ( if id = this.get(id) then { id: this.get(id) } else {} )
            klass ||= Skr.getObjectByName(definition.klass)
            #this._children[definition.name] = klass
            new klass(args)

    }


setupAssociations=(klass,definitions)->
    klass.derived ||= {}
    for definition in definitions
        klass.derived[ definition.name ] = associationDerivedDefinition(definition)
    klass._associations=definitions

setupStandardProps=(klass)->
    klass.props['id'] ||= 'number'
    klass.session['created_at'] ||= 'date'
    klass.session['updated_at'] ||= 'date'


setProps = (props,schema)->
    for type, fields of schema
        props[field] ||= type for field in fields

createAutoCollection = (klass)->
    Collection =  ->
        Skr.Data.Collection.prototype.constructor.apply(this,arguments)
    Collection.prototype.model = klass
    Skr.Data.Collection.extend(Collection)

Skr.Data.Model = Skr.lib.MakeBaseClass( Skr.Ampersand.Model, DataModel )



# Skr.Data.Model = Skr.Ampersand.Model.extend( DataModel.prototype )
# Skr.Data.Model.extend = Skr.lib.CreateExtendsChain(Skr.Ampersand.Model, Skr.Data.Model)






#Skr.Data.Model.

#     @api_path: ''


#     @fetch: (options)->
#         record = new this()
#         if Skr.u.isNumber(options)
#             record.id = options
#             options = {}
#         record.fetch(options)

#     save: (options)->
#         wrapResponse(this,options)
#         if options.saveAll
#             super(@attributes, options)
#         else
#             Skr.u.defaults( options, {patch: true})
#             dirty = this.dirtyData()
#             for association in this.associations
#                 if association.instance.isDirty()
#                     dirty[association.name] = association.instance.dirtyData()
#             super( dirty, options )

#     dirtyData: ->
#         Skr.u.pick( this.attributes, @unsavedAttributes... )

#     isDirty: ->
#         0 == @unsavedAttributes.length

#     set: (key,val,options)->
#         if typeof key == 'object'
#             attrs = key;
#             options = val;
#         else
#             (attrs = {})[key] = val
#         options || (options = {});
#         ret = super
#         unless options.silent || options.ignoreUnsaved
#             for name,val of attrs
#                 @unsavedAttributes.push( name ) if -1 == @unsavedAttributes.indexOf(name)
#         ret

#     parse:(resp)->
#         if Skr.u.isArray(resp['data']) then resp['data'][0] else resp['data']

#     fetch: (options={})->
#         super(Skr.u.extend(options,{limit:1,ignoreUnsaved:true}))


#     ensureAssociations: (names...,cb,scope)->
#         needed = Skr.u.filter( @associations, (assoc)->
#             Skr.u.contains(names, assoc.name) && ! assoc.instance.isLoaded()
#         )
#         if 0 == needed.length
#             cb.call(scope||this, this )
#             return this
#         else
#             this.fetch( include: Skr.u.pluck(needed,'name'), success: (rec)->
#                 cb.call(scope||rec, rec)
#             )
#             return this


#     constructor: () ->
#         original_init = this.initialize;
#         this.initialize = Skr.emptyFn
#         this.unsavedAttributes=[]
#         super
#         this._setupAssociation(association) for association in ( @associations ||= [] )
#         this.initialize=original_init;
#         this.initialize.apply(this, arguments);
#         this

#     initialize: (attributes={}, options={})->
#         @name ||= options.name || 'Model'
#         super(attributes, options)


#     url: ->
#         base = this.urlBase()
#         if @id then "#{base}/#{@id}.json"  else base + '.json'

#     toggle: (attribute)->
#         this.set( attribute, ! this.get(attribute) )

#     _setupAssociation:(assoc)->
#         klass = Skr.getObjectByName( assoc.model, 'Skr.Data')

#         if ( instance = this.get(assoc.name ) ) and ( instance instanceof klass )
#             this.attributes[ assoc.name ] = instance.attributes
#         else
#             instance = new klass( this.get(assoc.name), assoc.arguments )
#         assoc.instance = instance
#         instance.urlRoot = assoc.url if assoc.url
#         instance[ if assoc.inverse_name then assoc.inverse_name else 'association' ] = this
#         this[ assoc.name ] = instance

#         this.on("change:#{assoc.name}", (ev,data,opts)->
#             if Skr.u.isFunction( this.reset )
#                 this.reset(data)
#             else
#                 this.set( if (data instanceof Model) then data.attributes else data )
#         ,instance)



# copyServerMessages=(model,msg)->
#     return unless msg
#     model.errors = msg.errors
#     model.lastServerMessage = msg.message

# wrapResponse = (model, options)->
#     error   = options.error
#     success = options.success
#     options.error = (model,resp)->
#         copyServerMessages(model,resp.responseJSON)
#         error(arguments...) if error
#     options.success = (model,resp)->
#         model.unsavedAttributes = []
#         copyServerMessages(model,resp.responseJSON)
#         if ! options.success
#             error(arguments...) if error
#         else
#             success(arguments...) if success
