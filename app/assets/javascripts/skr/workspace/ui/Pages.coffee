class Skr.Workspace.UI.Pages extends Skr.View.Base

    initialize: (options)->
        @debounceMethod 'onResize'
        @interface = options.model
        this.listenTo( Skr.Data.Screens.displaying, "change:active", this.onActiveChange )
        super

    el: '<div class="page-content"><div class="screen"></div></div>'

    bindings:
        layout:
            selector: '.screen',  elAttribute: 'class',
            converter: (dir,value,attribute,model,el)-> "screen #{value}"


    onResize: ->
        screen = this.$('.screen')
        @model.set( screens_width: screen.width(), screens_height: screen.height() )

    render: ->
        super
        @defer ->
            this.$el.onresize( this.onResize )
        this

    onActiveChange: (screen,active)->
        return unless active
        this.$('.screen').html( screen.view().render().el )
