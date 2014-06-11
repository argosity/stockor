class Skr.Application
    constructor: (options)->
        Skr.u.extend(this,options)
        Skr.View.Assets.setPaths( options.paths )
        Skr.Data.Model.api_path=options.api_path;
        Skr.$(document).ready => @boot()

    boot: ->
        root = Skr.$(@root_element)
        @workspace = new Skr.Workspace.UI.Layout(el: root )
        @workspace.render()

        # FIXME - REMOVE WHEN DONE TESTING
        Skr.Data.Screens.all.findWhere( id: 'customer-maint' ).display()
