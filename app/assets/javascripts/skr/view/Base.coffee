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

    getSubView: (identifier)->
        @subViewInstances[identifier]

    setData: (data)->
        Skr.u.extend(this,data)
        for identifier, instance of @subViewInstances
            instance.setData?( this.argsForSubview( identifier, @subViews[identifier] ) )
        this.attachBindings()
        this

    resolveData: (path)->
        if Skr.u.isString(path)
            current = this
            for part in path.split('.')
                if current[part]
                    current = current[part]
                else
                    Skr.warn("Attempted to deref #{path}, but #{part} wasn't found")
            current
        else
            path

    argsForSubview: (identifier,options)->
        options = @resultsFor(options.options, identifier, options) if options.options
        args = switch
            when options.model
                {model: this.resolveData(options.model)}
            when options.collection
                {collection: this.resolveData(options.collection)}
            else
                {}
        Skr.u.extend(args, @resultsFor(options.arguments, identifier, options) )

    renderSubViews:->
        for identifier, options of @subViews
            args = this.argsForSubview(identifier,options)
            Skr.View.Helpers.context.push(identifier, args.model||args.collection)
            view = switch
                when options.component
                    this.renderComponent(identifier, options, args)
                when options.collection
                    this.renderCollectionSubview(identifier, options)
                else
                    this.renderPlainSubView(identifier, options, args)
            Skr.View.Helpers.context.pop()
            @subViewInstances[identifier] = view

    renderPlainSubView: ( identifier, options, args )->
        @subViewInstances[identifier].remove() if @subViewInstances[identifier]
        view = new options.view( args )
        this.$(options.selector).html( view.render().el )
        view

    renderComponent:( identifier, options, args )->
        @subViewInstances[identifier].remove() if @subViewInstances[identifier]
        options.component = Skr.Component[options.component] if Skr.u.isString( options.component )
        view = new options.component( args )
        this.$(options.selector).html( view.render().el )
        view

    renderCollectionSubview: (identifier, options )->
        @subViewInstances[identifier].unbind() if @subViewInstances[identifier]
        builder = if options.template
            new Skr.Backbone.CollectionBinder.ElManagerFactory(options.template, @resultsFor(options.options) )
        else
            new Skr.Backbone.CollectionBinder.ViewManagerFactory( (model)->
                new options.view( model: model )
            )
        binder = new Skr.Backbone.CollectionBinder( builder )
        el = if options.selector then this.$(options.selector) else this.$el
        binder.bind( Skr.u.result(this, options.collection), el )
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

    evalTemplate: (method)->
        return unless template_name = Skr.u.result(this,method)
        template = Skr.Templates.find(template_name, @namespace)

        Skr.fatal( "Template #{template_name} doesn't exist!" ) if ! template
        template(Skr.u.result(this,"#{method}Data"))

    renderTemplate: ->
        this.$el.html( this.evalTemplate('template') )

    render: ->
        super
        this.renderTemplate() if @template
        this.renderSubViews() if @subViews
        this.attachBindings() if @bindings
        this
