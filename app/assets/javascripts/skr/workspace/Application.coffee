class Skr.Application
    constructor: ->
        @workspace = new Skr.View.Workspace(el: Skr.$('body') )
        @workspace.render()
