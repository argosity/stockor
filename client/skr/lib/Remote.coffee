readLoadUrl = (matchRegex) ->
    src = document.createElement('a')
    for tag in document.querySelectorAll('script')
        if tag.src.match matchRegex
            src.href = tag.src
            Lanes.config.api_host = src.protocol + '//' + src.host
            Lanes.config.api_path = Lanes.config.api_host + "/api"
            break
    if Lanes.config.api_host
        css = src.href.replace(/\.js$/,'.css')
        new Lanes.lib.AssetLoader([css], Lanes.emptyFn)
    else
        console.error("Unable to find script tag that Stockor was loaded from")


Skr.lib.Remote = {

    onDocumentReady: (fn) ->
        if document.readyState isnt 'loading'
            fn()
        else if document.addEventListener
            document.addEventListener 'DOMContentLoaded', fn
        else
            document.attachEvent 'onreadystatechange', ->
                fn() if document.readyState != 'loading'

    configFromScriptTag: (matchRegex = /\/assets\/skr\/api\.js$/) ->
        new _.Promise (resolve) ->
            Skr.lib.Remote.onDocumentReady ->
                readLoadUrl(matchRegex)
                resolve(Lanes.config)

}
