class Skr.Workspace.UI.Navbar extends Skr.View.Base

    attributes:
        class: "navbar navbar-inverse navbar-fixed-top"
        role:  "navigation"

    template: 'navbar'

    events:
        'tap .screens-menu-toggle': 'switchMenu'
        'tap .navbar-toggle':  'showHideMenu'

    initialize: ->
        @tabs = new Skr.Workspace.UI.Tabs( model: @model )
        this.listenTo( Skr.Data.Screens.displaying, "change:active", this.onActiveChange )

    render: ->
        super
        this.$el.append( @tabs.render().el )
        this

    onActiveChange: ->
        this.$el.toggleClass('screens-menu-hidden',true)

    switchMenu: ->
        @model.nextSidebarState()

    showHideMenu: ->
        this.$el.toggleClass('screens-menu-hidden')

    swallowMenu:(menu)->
        this.$el
            .toggleClass('screens-menu-hidden',true)
            .append( menu.el )
