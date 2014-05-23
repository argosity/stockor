class Skr.Data.Model extends Skr.Supermodel.Model

    initialize: ->
        super(arguments)

    toggle: (attribute)->
        this.set( attribute, ! this.get(attribute) )
