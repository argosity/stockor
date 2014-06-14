Skr.Data.mixins.HasCodeField = {

    INVALID: /[^A-Z0-9a-z]/

    included: ->
        this.prototype.INVALID = Skr.Data.mixins.HasCodeField.INVALID
        this.prototype.initialize = Skr.u.wrap( this.prototype.initialize, (original,attributes,options)->
            original(attributes,options)
            this.on('change:code', this.upcaseCode )
        )

    upcaseCode: ->
        this.set('code', this.get('code').toUpperCase())
}
