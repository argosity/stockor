class Skr.Extension extends Lanes.Extensions.Base

    identifier: "skr"

    # Data that is provided by lib/skr/extension.rb's
    # client_bootstrap_data method ends up here
    setBootstrapData: (data) ->
        Skr.Models.GlAccount.initialize(
            accounts: data.gl_accounts
            default_ids: data.default_gl_account_ids,
        )

    rootComponent: (viewport) ->
        Lanes.Workspace.Layout
