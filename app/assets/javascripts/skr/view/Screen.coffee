Skr.namespace( 'View.Screens' )


class Skr.View.Screen extends Skr.View.Base

    attributes: {}

    constructor: (options)->
        this.screen = options.screen
        this.attributes['class'] || = ""
        this.attributes['class'] += this.screen.id
        super

    render: ->
        Skr.View.Helpers.context.start( this, this.model )
        super
        Skr.View.Helpers.context.reset()
        this
