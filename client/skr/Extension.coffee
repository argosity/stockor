class Skr.Extension extends Lanes.Extensions.Base

    identifier: "skr"

    # This method is called when the extension is registered
    # Not all of Lanes will be available yet
    onRegistered: ->

    # Data that is provided by lib/skr/extension.rb's
    # client_bootstrap_data method ends up here
    setBootstrapData: (data)->
        Skr.Models.GlAccount.initialize(data)

    # All of lanes is loaded and it is in the process of booting
    onAvailable: ->
