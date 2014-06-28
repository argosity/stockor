Skr.namespace("Extension")

class Skr.Data.Extensions

    @register: (klass)->
        type = Skr.getObjectByName(klass)
        debugger