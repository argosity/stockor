class Skr.View.Base extends Skr.Backbone.View

    subViews: {}

    constructor:->
        @binder = new Skr.Backbone.ModelBinder()
        @subViewInstances={}
        super

    remove: ->
        @binder.unbind();
        for el, instance of @subViewInstances
            if instance.unbind
                options.instance.unbind()
            else
                options.instance.remove()
        super

    renderSubViews:->
        for selector, options of @subViews
            @subViewInstances[selector] = switch
                when options.component
                    this.renderComponent(selector, options)
                when options.collection
                    this.renderCollectionSubview( selector, options.collection, options.view )
                else
                    this.renderSubView(selector, options )

    renderSubView: ( selector, options )->
        @subViewInstances[selector].remove() if @subViewInstances[selector]
        view = new options.view( model: options.model )
        this.$(selector).html( view.render().el )
        view

    renderComponent:( selector, options )->
        @subViewInstances[selector].remove() if @subViewInstances[selector]
        options.component = Skr.Component[options.component] if Skr.u.isString( options.component )
        args = if options.model then {model: this[options.model]} else {collection: this[options.collection]}
        view = new options.component(args)
        this.$(selector).html( view.render().el )
        view

    renderCollectionSubview: ( selector, collection, viewClass )->
        @subViewInstances[selector].unbind() if @subViewInstances[selector]
        builder = new Skr.Backbone.CollectionBinder.ViewManagerFactory( (model)->
            new viewClass( model: model )
        )
        binder = new Skr.Backbone.CollectionBinder( builder )
        binder.bind( Skr.u.result(this, collection), this.$(selector) )
        binder

    render: ->
        super
        if @template
            view = "#{Skr.u.result(this,'template')}"
            template = Skr.Templates[view]
            Skr.fatal( "Template #{view} doesn't exist!" ) if ! template
            this.$el.html ( template() )
        bindings = Skr.u.extend(
                Skr.Backbone.ModelBinder.createDefaultBindings(this.el, 'name'),
                Skr.u.result(this, 'bindings' )
        )
        @binder.bind( @model, @el, bindings ) if @model
        this.renderSubViews()
        this
