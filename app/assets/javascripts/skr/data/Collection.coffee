class Skr.Data.Collection extends Skr.Backbone.Collection

    initialize: ->
        @isLoaded = this.length > 0;
        super(arguments)

    fetch: (options)->
        @isLoaded = true
        super(options)

    ensureLoaded: ( callback )->
        if ! @isLoaded && ! this.length
            this.fetch({ success: callback })
        else if callback
            callback()

    url: ->
        url = if _.isFunction( this.urlRoot ) then this.urlRoot() else null
        return if url? then SKR.Data.makeURL( url ) else ''

    viewJSON: (options)->
        this.map( (model) ->
            model.viewJSON(options)
        )
