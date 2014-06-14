class Skr.Workspace.UI.Pages extends Skr.View.Base

    el: '<div class="page-content"><div class="screen"></div></div>'

    bindings:
        layout:
            selector: '',  elAttribute: 'class',
            converter: (dir,value,attribute,model,el)-> "page-content #{value}"

    initialize: (options)->
        @debounceMethod 'onResize'
        this.listenTo( Skr.Data.Screens.displaying, "change:active", this.onActiveChange )
        this.listenTo( Skr.Data.Screens.displaying, "remove",        this.onRemove )
        super

    onResize: ->
        screen = this.$('.screen')
        @model.set( screens_width: screen.width(), screens_height: screen.height() )

    render: ->
        super
        @model.set(viewport: this.$el)
        @defer ->
            this.$el.onresize( this.onResize )
        this

    onRemove: (screen)->
        this.$('.screen').html('') if this.$('.screen').children()[0] == screen.viewInstance.el

    onActiveChange: (screen,active)->
        return unless active
        this.$('.screen').html( screen.view().el )
