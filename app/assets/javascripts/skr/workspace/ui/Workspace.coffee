class Skr.Workspace.UI.Layout extends Skr.View.Base

    bindings:
        screen_menu_size:
            selector: '.page-container',  elAttribute: 'class',
            converter: (dir,value,attribute,model,el)-> "screens-menu-#{value}"

    initialize: ->
        @debounceMethod 'onResize'
        @model   = Skr.View.InterfaceState
        this.listenTo(@model,'change:screen_menu_position', this.moveScreensMenu )
        @navbar  = new Skr.Workspace.UI.Navbar( model: @model )
        @pages   = new Skr.Workspace.UI.Pages(  model: @model )
        @screens = new Skr.Workspace.UI.ScreensMenu( model: @model )
        super

    onResize: ->
        this.updateInterfaceDimmensions()

    updateInterfaceDimmensions: ->
        @model.set( viewport_width: this.$el.width(), viewport_height: this.$el.height() )

    render: ->
        this.updateInterfaceDimmensions()
        menu = @model.get('screen_menu_size')
        this.$el
            .addClass("stockor")
            .html( @navbar.render().el )
            .append( "<div class='page-container screens-menu-#{menu}'></div>" )
        this.$('.page-container')
            .append( @pages.render().el )
        @screens.render()
        @defer ->
           this.$el.onresize( this.onResize )

        @model.set(viewport: this.$el)
        super
        this.moveScreensMenu()
        this


    moveScreensMenu: ->
        if 'top' == @model.get("screen_menu_position")
            @navbar.swallowMenu( @screens )
        else
            @screens.$el.appendTo('.page-container')
