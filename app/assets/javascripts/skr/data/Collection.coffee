class Skr.Data.Collection extends Skr.Backbone.Collection

    Skr.lib.ModuleSupport.includeInto(this)

    initialize: ->
        @isLoaded = this.length > 0;
        super(arguments)

    isLoaded:->
        @isLoaded

    fetch: (options)->
        @isLoaded = true
        super(options)

    ensureLoaded: ( callback )->
        if ! @isLoaded && ! this.length
            this.fetch({ success: callback })
        else if callback
            callback()

    isDirty: ->
        false

    parse:(resp)->
        resp['data']

    url: ->
        @model.prototype.urlBase() + '.json'

    viewJSON: (options)->
        this.map( (model) ->
            model.viewJSON(options)
        )
