class Skr.View.Navbar extends Skr.View.Base

    attributes:
        class: "navbar navbar-inverse navbar-fixed-top"
        role:  "navigation"

    template: 'navbar'

    events:
        'tap .screens-menu-toggle': 'switchMenu'
        'tap .navbar-toggle':  'showHideMenu'

    initialize: ->
        @tabs = new Skr.View.Tabs( model: @model )

    render: ->
        super
        this.$el.append( @tabs.render().el )
        this

    switchMenu: ->
        @model.nextSidebarState()


    showHideMenu: ->
        this.$el.toggleClass('screens-menu-hidden')

    swallowMenu:(menu)->
        this.$el
            .toggleClass('screens-menu-hidden',true)
            .append( menu.el )
