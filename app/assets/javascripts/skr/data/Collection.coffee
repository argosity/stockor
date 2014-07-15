class DataCollection

    constructor: ->
        @isLoaded=false
        Skr.Ampersand.Collection.apply(this, arguments)

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

    viewJSON: (options)->
        this.map( (model) ->
            model.viewJSON(options)
        )

    url: ->
        @model.prototype.urlRoot() + '.json'


Skr.Data.Collection = Skr.lib.MakeBaseClass( Skr.Ampersand.Collection, DataCollection )
