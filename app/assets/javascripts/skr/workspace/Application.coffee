class Skr.Application
    constructor: (options)->
        Skr.View.Assets.setPaths( options.paths )
        @workspace = new Skr.View.Workspace(el: Skr.$('body') )
        @workspace.render()

    asset_paths: (paths)->
        debugger