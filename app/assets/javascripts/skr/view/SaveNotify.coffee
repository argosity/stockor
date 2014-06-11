
class ModelSaver

    constructor: ( @element, options )->
        @options = options
        @mask = new Skr.View.TimedMask( @element, options.message )
        @mask.prefixActions( "Save" )
        Skr.u.bindAll(this,'_onError','_onSuccess')
        options.model.save({
            success: this._onSuccess, error: this._onError
        })
        this

    _onSuccess: (rec,resp,options)->
        @mask.displaySuccess()
        this._callback(true,resp)

    _onError: (rec,resp,options)->
        @mask.displayFailure(rec.lastServerMessage)
        this._callback(false,resp)

    _callback: (success,resp)->
        @options.callback(success,resp,@options.model) if @options.callback


Skr.View.SaveNotify = ( view, options )->
    el = if view.jquery then view else view.$el
    Skr.u.defaults( options, { model: view.model, message: "Saving, Please Wait…"} )
    new ModelSaver(el, options)
