Skr.emptyFn = ->

Skr.fatal = (msg)->
    console.warn msg if console
    throw new Error(msg)

Skr.log = (msg)->
    console.log(msg) if console.log

distillTypes = (type)->
    Skr.u.reduce( type.split( '.' ), ( ( memo, val )-> return memo[ val ] ),  window )

Skr.getObjectByName = ( name, defaultns='Skr' ) ->
    distillTypes(name) || distillTypes(defaultns + '.' + name)
