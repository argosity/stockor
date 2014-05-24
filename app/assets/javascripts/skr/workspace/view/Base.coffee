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
            if options.collection
                @subViewInstances[selector].unbind() if @subViewInstances[selector]
                @subViewInstances[selector] = this.bindCollectionSubview( selector, options.collection, options.view )
            else
                @subViewInstances[selector].remove() if @subViewInstances[selector]
                @subViewInstances[selector] = new options.view( model: options.model )

    bindCollectionSubview: ( specifier, collection, viewClass )->
        builder = new Skr.Backbone.CollectionBinder.ViewManagerFactory( (model)->
            new viewClass( model: model )
        )
        binder = new Skr.Backbone.CollectionBinder( builder )

        binder.bind( Skr.u.result(this, collection), this.$(specifier) )
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
        @binder.bind( @model, @el, bindings )
        this.renderSubViews()
        this
