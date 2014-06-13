class Skr.Component.Address extends Skr.Component.Base

    template: 'address'
    attributes:
        class:"address"

    bindings:
        model:{ default: true }

    initialize: (options)->
        @copyFrom = options.copyFrom
        this.setupCopyFrom()
        super

    setData: (data)->
        super
        this.setupCopyFrom()
        this

    setupCopyFrom:->
        return unless @copyFrom
        this.listenTo(this.copyFrom.model,'change', @applyChange )

    applyChange: (model,value,field)->
        for name,value of model.changed
            this.model.set(name,value) if this.model.get(name) == model.previous(name)
