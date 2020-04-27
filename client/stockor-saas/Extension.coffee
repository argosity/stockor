# This is the client-side version of StockorSaas::Extension
class StockorSaas.Extension extends Lanes.Extensions.Base

    # must match the server-side identier in config/screens.rb and lib/stockor-saas/extension.rb
    identifier: "stockor-saas"

    # This method is called when the extension is registered
    # Not all of Lanes will be available yet
    onRegistered: Lanes.emptyFn

    # This method is called after Lanes is completly loaded
    # and all extensions are registered
    onInitialized: Lanes.emptyFn

    # All extenensions have been given their data and Lanes has completed startup
    onAvailable: ->
        Rollbar?.configure(enabled: Lanes.config.env.production)
        @configureRollbar() if Lanes.current_user.isLoggedIn
        Lanes.current_user.on('change:isLoggedIn', @configureRollbar)

    configureRollbar: ->
        Rollbar?.configure(
            payload: {
                user: {id: Lanes.current_user.id}
            }
        )

    title: ->
        @data?.tenant?.title || 'Stockor'

    # Routes that should be established go here
    getRoutes: -> null

    # The root component that should be shown for this extension.
    # Will not be called if a different extension has included this one and it is the
    # "controlling" extension
    rootComponent: (viewport) ->
        Lanes.Workspace.Layout
