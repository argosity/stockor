Skr.namespace( 'View.Screens' )

class Skr.View.Screen extends Skr.View.Base

    attributes: {}

    constructor: (options)->
        this.screen = options.screen
        this.template = this.screen.id if Skr.u.isUndefined(this.template)
        this.attributes['class'] || = ""
        this.attributes['class'] += this.screen.id
        super
