class Skr.View.Workspace extends Skr.View.Base

    bindings: -> {
        screen_menu_size: {
            selector: '#page-container',  elAttribute: 'class',
            converter: (dir,value,attribute,model,el)-> "screens-menu-#{value}"
        }
    }

    initialize: ->
        Skr.$(window).resize @onResize
        @model   = new Skr.Data.InterfaceState
        this.listenTo(@model,'change:screens_menu_position', this.moveScreensMenu )
        @navbar  = new Skr.View.Navbar(  model: @model )
        @pages   = new Skr.View.Pages(   model: @model )
        @screens = new Skr.View.ScreensMenu( model: @model )
        super

    render: ->
        this.$el.html( @navbar.render().el )
        this.$el.append( '<span class="foo"></span>' )
        this.$el
            .append( '<div id="page-container"></div>' )
        this.$('#page-container')
            .append( @pages.render().el )
        @screens.render()
        this.onResize()
        super
        this

    onResize: =>
        if Skr.$(window).width() < 768
            @model.set( screens_menu_position: 'top' )
        else
            @model.set( screens_menu_position: 'side' )

    moveScreensMenu: (model,position)->
        if 'top' == position
            @navbar.swallowMenu( @screens )
        else
            @screens.$el.appendTo('#page-container')
