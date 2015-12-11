class Skr.Extension extends Lanes.Extensions.Base

    identifier: "skr"

    # Data that is provided by lib/skr/extension.rb's
    # client_bootstrap_data method ends up here
    setBootstrapData: (data) ->
        Skr.Models.GlAccount.initialize(
            accounts: data.gl_accounts
            default_ids: data.default_gl_account_ids,
        )
        Skr.Models.Location.initialize(
            locations: data.locations
        )
        for type, choices of data.templates
            klass = Skr.Models[_.classify(type)]
            if klass
                klass.Templates = choices
            else
                console.log "Unable to find model for #{type}"


    rootComponent: (viewport) ->
        Lanes.Workspace.Layout

    preferenceElement: (props) ->
        React.createElement(SC.UserPreferences, key: 'skr')
