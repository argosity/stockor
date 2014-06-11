
module_names = []
modules = {}

previousDefine = window.define

window.define = (name,deps,callback)->
    callback = arguments[arguments.length-1] if ! callback
    if 0 == module_names.length
        console.warn "define called by #{name || callback.name} but not expecting any modules" if console && console.warn
    else
        modules[module_names.shift()]=callback(modules)

methods = {

    amd: {
        jQuery: true
    }

    expectModules: (names...)->
        module_names = module_names.concat(names)

    module: (name)->
        return modules[name]

    noConflict: ->
        window.define = previousDefine
        return this;

}

window.define[name] = method for name,method of methods