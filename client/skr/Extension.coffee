#= require ./screens/customer-maint

class Skr.Extension extends Lanes.Extensions.Base

    identifier: "skr"

    setBootstrapData: (data)->


    onAvailable: ->
        _.delay ->
            Lanes.Screens.display_id("customer-maint")
