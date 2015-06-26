class Skr.Extension extends Lanes.Extensions.Base

    identifier: "skr"

    # Data that is provided by lib/skr/extension.rb's
    # client_bootstrap_data method ends up here
    setBootstrapData: (data) ->
        Skr.Models.GlAccount.initialize(data)

    rootComponent: (viewport) ->
        Lanes.Workspace.Layout

    onAvailable: ->
        Lanes.Screens.Definitions.all.get('customer-maint').display()
