class Skr.View.TimedMask
    stages:
        pending:
            msg: "Please Wait …"
            icon: "loading-spinner"
            color: 'darkGrey';
        success:
            msg: "Success!"
            icon: "icon-thumbs-up"
            color: 'blue'
        failure:
            msg: "Failed"
            icon: "icon-warning"
            color: 'darkRed'
        timeout:
            msg: "Timed Out …"
            icon: "icon-busy"
            color: 'firebrick'

    timeout: 27000 # 30 seconds

    constructor: ( @element, options={} )->
        if Skr.u.isString( options )
            @stages.pending.msg = options
        else
            Skr.u.defaults(this, options)
        @element.overlay( @stages.pending )

        @timeout = Skr.u.delay( =>
            @_failSafeDestruct()
        ,@timeout)
        this

    prefixActions: (msg)->
        stage.msg ="#{msg} #{stage.msg}" for stage in @stages

    display: (success, msg)->
        if success then this.displaySuccess(msg) else this.displayFailure(msg)

    displaySuccess: ( msg = @stages.success.msg, opts={}  )->
        this._display( msg, opts, 'success' )

    displayFailure: ( msg = @stages.failure.msg, opts={} )->
        this._display( msg, opts, 'failure' )

    _display:(msg, opts, stage)->
        this._sceduleDestruct( opts.timeOut )
        opts = Skr.u.extend( Skr.u.clone(@stages[stage]), opts)
        Skr.u.extend(opts, {msg:msg}) if msg
        console.log opts
        @element.overlay( opts )

    _failSafeDestruct: ->
        debugger
        this._display( null, {timeOut: 5000}, 'timeout' )

    _sceduleDestruct: (time=3000)->
        clearTimeout(@timeout)
        @timeout = Skr.u.delay( =>
            @destroy()
        ,time)

    destroy: ->
        @element.overlay(false)
        clearTimeout(@timeout)
