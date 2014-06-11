Skr.lib.results = {
    # Like underscore's results but allows passing
    # arguments to the function if it's called
    resultsFor:( method, args... )->
         if Skr.u.isFunction(this[method]) then this[method].apply(this,args) else this[method]
}
