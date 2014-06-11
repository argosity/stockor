Skr.lib.defer = {
    defer: (fn, options={})->
        scope = options.scope || this
        Skr.u.delay( ->
            fn.apply(scope,options.arguments)
        ,options.delay||1)
}
