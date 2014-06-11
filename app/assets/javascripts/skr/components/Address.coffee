class Skr.Component.Address extends Skr.Component.Base

    template: 'address'
    attributes:
        class:"address"

    bindings:
        model:{ default: true }

    initialize: ->
        super
        this.listenTo(@model, 'change', (m)->
            console.log @model.cid
        )

    render: ->
        # console.log "rendr address"
        # console.log @model.cid
        super