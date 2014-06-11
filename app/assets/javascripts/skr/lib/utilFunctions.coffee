Skr.emptyFn = ->

Skr.fatal = (msg)->
    console.warn msg if console
    throw new Error(msg)

Skr.log = (msg)->
    console.log(msg) if console.log
