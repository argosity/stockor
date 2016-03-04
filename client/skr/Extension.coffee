class Skr.Extension extends Lanes.Extensions.Base

    identifier: "skr"

    # Data that is provided by lib/skr/extension.rb's
    # client_bootstrap_data method ends up here
    setBootstrapData: (data) ->
        Lanes.Models.Query.LIKE_QUERY_TYPES.push 'visible_id'
        Skr.Models.GlAccount.initialize(
            accounts: data.gl_accounts
            default_ids: data.default_gl_account_ids,
        )
        Skr.Models.Location.initialize(
            locations: data.locations
        )
        Skr.Models.PaymentTerm.initialize(
            payment_terms: data.payment_terms
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
    settingsElement: (props) ->
        React.createElement(SC.SystemSettings, key: 'skr')
