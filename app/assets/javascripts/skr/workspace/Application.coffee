class Skr.Application
    constructor: (options,extension_data)->
        Skr.u.extend(this,options)
        #Skr.View.Assets.setPaths( options.paths )
        @view = Skr.getObjectByName(options.view)
        Skr.Data.Model.api_path=options.api_path;
        Skr.Extensions.setBootstrapData(extension_data);
        Skr.Data.GlAccounts.bootstrap(extension_data.gl_accounts) if extension_data.gl_accounts
        Skr.$(document).ready => @boot()

    boot: ->
        root = Skr.$(@element)
        this.view = new this.view(el: root ).render()
        Skr.Extensions.fireOnAvailable(this)

        # FIXME - REMOVE WHEN DONE TESTING
        Skr.Data.Screens.all.findWhere( id: 'customer-maint' ).display()
