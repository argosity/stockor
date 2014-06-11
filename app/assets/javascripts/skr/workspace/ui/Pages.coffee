class Skr.Workspace.UI.Pages extends Skr.View.Base

    attributes:
        class: "page-content"

    template: 'pages'

    initialize: ->
        this.listenTo( Skr.Data.Screens.displaying, "change:active", this.onActiveChange )
        this.listenTo( Skr.Data.Screens.displaying, "add", this.onAdd )
        super

    onAdd: (screen)->
        view = screen.view()
        this.$el.html( view.el )
        view.render()

    onActiveChange: (screen,active)->
        return unless active
        this.$el.html( screen.view().el )
