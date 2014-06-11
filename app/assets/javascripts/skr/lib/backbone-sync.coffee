
# a simple reimplentation
# to use traffic cop
methodMap = {
    'create': 'POST',
    'update': 'PUT',
    'patch':  'PATCH',
    'delete': 'DELETE',
    'read':   'GET'
}

getValue = (object, prop)->
    if !(object && object[prop])
        return null;
    return if _.isFunction(object[prop]) then object[prop]() else object[prop];


Skr.Backbone.Model.prototype.getValuesHash = ( names... )->
    ret = {}
    for name in names
        ret[ name ] = this.get( name )
    ret

Skr.Backbone.Model.prototype.getPrefixedValuesHash = ( prefix, names... )->
    ret = {}
    for name in names
        ret[ prefix+name ] = this.get( name )
    ret

urlError = ->
    throw new Error('A "url" property or function must be specified')


paramsMap = {
    f: 'fields'
    w: 'with'
    q: 'query'
    i: 'include'
    o: 'order'
    l: 'limit'
    s: 'start'
}

Skr.Backbone.sync = (method, model, options)->

    q = {}

    for key, name of paramsMap
        q[key] = options[name] if options[name]

    # Default JSON-request options.
    params =
        type: methodMap[method]
        dataType: "json"
        data: q

    # Ensure that we have a URL.
    params.url = Skr.u.result(model, "url") or urlError() unless options.url

    # Ensure that we have the appropriate request data.
    if not options.data? and model and (method is "create" or method is "update" or method is "patch")
        params.contentType = "application/json"
        params.data = JSON.stringify( { data: ( options.attrs || model.toJSON(options ) ) } )

    # Don't process data on a non-GET request.
    params.processData = false if params.type isnt "GET"

    # If we're sending a `PATCH` request, and we're in an old Internet Explorer
    # that still has ActiveX enabled by default, override jQuery to use that
    # for XHR instead. Remove this line when jQuery supports `PATCH` on IE8.
    if params.type is "PATCH" and window.ActiveXObject and not (window.external and window.external.msActiveXFilteringEnabled)
        params.xhr = ->
            new ActiveXObject("Microsoft.XMLHTTP")

    # Make the request, allowing the user to override any Ajax options.
    xhr = options.xhr = Skr.Backbone.ajax(Skr.u.extend(params, options))
    model.trigger "request", model, xhr, options
    xhr
