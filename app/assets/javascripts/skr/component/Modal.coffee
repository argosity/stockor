class Skr.Component.Modal extends Skr.Component.Base

    template: 'modal'
    templateData: ->
        title: @title
        buttons: @buttons

    attributes:
        class:"modal fade"
        tabindex:"-1"
        role: "dialog"

    forwardEvents:[
        'show.bs.modal'
        'shown.bs.modal'
        'hide.bs.modal'
        'hidden.bs.modal'
        'loaded.bs.modal'
    ]

    buttons:
        close: { label: 'Close', type: 'default', dismiss: true }

    initialize: (options)->
        Skr.u.extend(this,options)
        Skr.u.bindAll(this,'forwardModalEvent')
        for event in @forwardEvents
            this.$el.on(event, @forwardModalEvent )
        super

    forwardModalEvent: (ev)->
        this.trigger(ev.type, this)

    renderTemplate: ->
        super
        this.$('.modal-body')
            .attr( Skr.u.result(this,'bodyAttributes') )
            .addClass('modal-body')
            .html( this.evalTemplate('bodyTemplate') )
        this

    close:->
        #this.trigger('hide',this)
        this.$el.modal('hide')

    show: ->
        this.render()
        this.$el.modal()
