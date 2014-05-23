# idea & basic implemntation from https://github.com/jashkenas/coffee-script/wiki/FAQ
window.Skr ||= {}

Skr.namespace = (target, name, block) ->
    [target, name, block] = [(if typeof exports isnt 'undefined' then exports else Skr), arguments...] if arguments.length < 3
    top    = target
    target = target[item] or= {} for item in name.split '.'
    block( target, top ) if typeof block == 'function'
