Skr.Api.Components.Base =

    # Pass coponent onthrough to Lanes default
    # Skr.Api.Components.Base is only here to provide
    # an extension point that may be needed in the future
    extend: (klass) ->
        Lanes.React.Component.extend(klass)
