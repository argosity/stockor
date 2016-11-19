readLoadUrl = (matchRegex) ->
    for tag in document.querySelectorAll('script') when tag.src.match matchRegex
        Lanes.config.api_host = tag.src.replace(/\/assets\/.*/, '')
        css = tag.src.replace(/\.js$/, '.css')
        new Lanes.lib.AssetLoader([css], Lanes.emptyFn)
        break
    unless Lanes.config.api_host
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
