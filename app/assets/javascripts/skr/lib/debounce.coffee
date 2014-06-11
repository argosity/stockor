
Skr.lib.debounce = {
    debounce: (fn, options={})->
        options.scope ||= this
        options.delay ||= 250
        Skr.u.debounce( ->
            fn.apply(options.scope, options.arguments)
        , options.delay )

    debounceMethod: (method,options)->
        original = this[method]
        this[method] = @debounce( ->
            original.apply(this, arguments)
        ,options)
}
