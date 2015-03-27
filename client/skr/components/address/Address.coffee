class Skr.Components.Address extends Lanes.Components.Base


    writeTemplateName: -> 'address'

    constructor: (options={})->
        super
        this.access = 'write'
        if @copyFrom = options.copyFrom
            this.bindCopyFrom()
            this.listenTo(this.copyFrom,'change:model', @bindCopyFrom )

    bindCopyFrom: ->
        old = this.copyFrom.changedAttributes()['model']
        this.stopListening( old, 'change', @applyChange    ) if old
        this.listenTo(this.copyFrom.model,'change', @applyChange )

    applyChange: (model,value,field)->
        for name,value of model.changedAttributes()
            this.model.set(name,value) if this.model.get(name) == model.previous(name)
