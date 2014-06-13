Skr.lib.results = {
    # Like underscore's results but allows passing
    # arguments to the function if it's called
    resultsFor:( method, args... )->
        if Skr.u.isString(method)
            if Skr.u.isFunction(this[method])
                this[method].apply(this,args)
            else
                this[method]
        else if Skr.u.isFunction(method)
            method.apply(this,args)
        else
            method

}
