readLoadUrl = (matchRegex) ->
    for tag in document.querySelectorAll('script')
        if tag.src.match matchRegex
            Lanes.config.api_host = tag.src.replace(SCRIPT_PATH, '')
            Lanes.config.api_path = Lanes.config.api_host + "/api"
            break
    if Lanes.config.api_host
        css = Lanes.config.api_host + "/assets/skr/api.css"
        new Lanes.lib.AssetLoader([css], Lanes.emptyFn)
    else
        console.error("Unable to find script tag that Stockor was loaded from")

Skr.Remote = {

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
            @onDocumentReady ->
                readLoadUrl()
                resolve(Lanes.config)

}