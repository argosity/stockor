class Skr.View.Base extends Skr.Backbone.View

    Skr.lib.ModuleSupport.includeInto(this)

    @include Skr.lib.defer
    @include Skr.lib.debounce
    @include Skr.lib.results

    constructor:->
        @binder = new Skr.Backbone.ModelBinder()
        @subViewInstances={}
        super


    remove: ->
        @binder.unbind();
        for el, instance of @subViewInstances
            ( instance.unbind || instance.remove )()
        super

    renderSubViews:->
        for selector, options of @subViews
            @subViewInstances[selector] = switch
                when options.component
                    this.renderComponent(selector, options)
                when options.collection
                    this.renderCollectionSubview(selector, options)
                else
                    this.renderSubView(selector, options )


    getSubView: (selector)->
        @subViewInstances[selector]

    setData: (data)->
        Skr.u.extend(this,data)
        for selector, instance of @subViewInstances
            instance.setData( this.argsForSubview( @subViews[selector] ) )
        this.attachBindings()
        this

    resolveData: (path)->
        if Skr.u.isString(path)
            current = this
            for part in path.split('.')
                if current[part]
                    current = current[part]
                else
                    Skr.fatal("Attempted to deref #{path}, but #{part} wasn't found")
            current
        else
            path

    argsForSubview: (options,selector)->
        options = @resultsFor(options.options, selector, options) if options.options
        args = switch
            when options.model
                {model: this.resolveData(options.model)}
            when options.collection
                {collection: this.resolveData(options.collection)}
            else
                {}
        Skr.u.extend(args, options.arguments)


    renderSubView: ( selector, options )->
        @subViewInstances[selector].remove() if @subViewInstances[selector]
        view = new options.view( this.argsForSubview(options,selector) )
        this.$(selector).html( view.render().el )
        view

    renderComponent:( selector, options )->
        @subViewInstances[selector].remove() if @subViewInstances[selector]
        options.component = Skr.Component[options.component] if Skr.u.isString( options.component )
        view = new options.component( this.argsForSubview(options,selector) )
        this.$(selector).html( view.render().el )
        view

    renderCollectionSubview: (selector, options)->
        @subViewInstances[selector].unbind() if @subViewInstances[selector]
        builder = if options.template
            new Skr.Backbone.CollectionBinder.ElManagerFactory(options.template, options.options)
        else
            new Skr.Backbone.CollectionBinder.ViewManagerFactory( (model)->
                new options.view( model: model )
            )
        binder = new Skr.Backbone.CollectionBinder( builder )
        binder.bind( Skr.u.result(this, options.collection), this.$(selector) )
        binder

    attachBindings: ->
        @binder.unbind()
        model_bindings = {}
        for model_field, options of Skr.u.result(this,'bindings')
            if options && options.default
                el = if options.el then this.$(options.el) else @el
                @binder.bind( this[model_field], el,
                    Skr.Backbone.ModelBinder.createDefaultBindings(el, 'name')
                )
            else
                 parts = model_field.split('.')
                 parts.unshift('model') if 1 == parts.length
                 model_bindings[ parts[0] ] ||= {}
                 model_bindings[ parts[0] ][ parts[1] ]=options

        for binding_model,options of model_bindings
            @binder.bind( this[binding_model], @el, options, Skr.u.result(this,'bindingOptions') )

    evalTemplate: (name)->
        return unless view = Skr.u.result(this,name)
        template = Skr.Templates[view]
        Skr.fatal( "Template #{view} doesn't exist!" ) if ! template
        template(Skr.u.result(this,"#{name}Data"))

    renderTemplate: ->
        this.$el.html( this.evalTemplate('template') )

    render: ->
        super
        this.renderTemplate() if @template
        this.renderSubViews() if @subViews
        this.attachBindings() if @bindings
        this
