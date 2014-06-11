class Skr.Application
    constructor: (options)->
        Skr.View.Assets.setPaths( options.paths )
        debugger
        Skr.Data.Model.api_path=options.api_path;

        @workspace = new Skr.Workspace.UI.Layout(el: Skr.$('body') )
        @workspace.render()
        Skr.Data.Screens.all.findWhere( id: 'customer-maint' ).display()
