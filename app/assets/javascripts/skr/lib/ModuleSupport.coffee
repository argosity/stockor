moduleKeywords = ['extended', 'included']

class Skr.lib.ModuleSupport
    @includeInto: (klass)->
        Skr.u.extend(klass,this)

    @extend: (obj) ->
        for key, value of obj when key not in moduleKeywords
            this[key] = value

        obj.extended?.apply(@)
        this

    @include: (obj) ->
        for key, value of obj when key not in moduleKeywords
            # Assign properties to the prototype
            @::[key] = value
        obj.included?.apply(@)
        this
