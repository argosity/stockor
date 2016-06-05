Skr.onDocumentReady = (fn) ->
    if document.readyState isnt 'loading'
        fn()
    else if document.addEventListener
        document.addEventListener 'DOMContentLoaded', fn
    else
        document.attachEvent 'onreadystatechange', ->
            fn() if document.readyState != 'loading'


SCRIPT_PATH = /\/assets\/skr\/api\.js$/

Skr.onDocumentReady ->
    for tag in document.querySelectorAll('script')
        if tag.src.match SCRIPT_PATH
            Lanes.config.api_host = tag.src.replace(SCRIPT_PATH, '')
            Lanes.config.api_path = Lanes.config.api_host + "/api"
            break
    if Lanes.config.api_host
        css = Lanes.config.api_host + "/assets/skr/api.css"
        new Lanes.lib.AssetLoader([css], Lanes.emptyFn)
    else
        console.error("Unable to find script tag that Stockor was loaded from")
