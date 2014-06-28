Skr.emptyFn = ->

Skr.fatal = (args...)->
    Skr.warn(args...)
    throw new Error(msg)

Skr.warn = (msg...)->
    console.warn(msg...) if console

Skr.log = (msg...)->
    console.log(msg...) if console


distillTypes = (type)->
    Skr.u.reduce( type.split( '.' ), ( ( memo, val )-> return if memo then memo[ val ] else null ),  window )

Skr.getObjectByName = ( name, defaultns='Skr' ) ->
    distillTypes(name) || distillTypes(defaultns + '.' + name)
