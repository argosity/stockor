class Skr.View.FormBindings

    constructor: (@view, @keypath, @selector)->
        Skr.u.bindAll(this,'onInputChange')
        @selector = "#{@selector} " if @selector
        @view.on( "change:el",          this.onElChange,    this )
        @view.on( "change:#{@keypath}", this.onModelChange, this )
        @view.on( "remove",             this.teardown,      this )
        this.onModelChange( @view, @model() )

    teardown: ->
        this.model().off( "change", this.onModelUpdate )


    onInputChange: (ev)->
        el = Skr.$(ev.target)
        el[0]._is_setting=true
        this.model().set( el.attr('name'),el.val() )
        delete el[0]._is_setting


    onElChange: (view, el)->
        input_selector = "#{@selector}input"
        if old_el = @view.changedAttributes()['el']
            Skr.$(el).off("change", input_selector, this.onInputChange )
        Skr.$(el).on("change",input_selector, this.onInputChange )

    onModelChange: (view, model)->
        if old_model = @view.changedAttributes()[@keypath]
            old_model.off( "change", this.onModelUpdate )
        console.log 'model chaged for %o', model
        this.onModelUpdate(model, { all: true } )
        model.on('change', this.onModelUpdate, this );


    onModelUpdate: (model, opts={})->
        inputs = Skr.$(@view.el).find("#{@selector} input")
        attributes = if opts.all then model.attributes else model.changedAttributes()
        for name, value of attributes
            el = Skr.u.findWhere( inputs, { name: name })
            this.setElValue(Skr.$(el),value) if el && ! el._is_setting

    model: ->
        Skr.u.getPath(@view,@keypath)

    setElValue:  (el, value)->
        console.log "Set EL: %o", el[0]
        if el.attr('type')
            switch el.attr('type')
                when 'radio'
                    el.prop('checked', el.val() == value)
                when 'checkbox'
                     el.prop('checked', !!value)
                when 'break'
                    file;
                else
                    el.val(value)

        else if el.is('input') || el.is('select') || el.is('textarea')
            el.val(value ||  ( if value == 0 then '0' else '') )
        else
            el.text(value || ( if value == 0 then '0' else '') )
