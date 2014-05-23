Skr.fatal = (msg)->
    console.warn msg if console
    throw new Error(msg)
