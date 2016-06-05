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
            Lanes.config.api_path = tag.src.replace(SCRIPT_PATH, '') + "/api"
            break
    unless Lanes.config.api_path
        console.error("Unable to find script tag that Stockor was loaded from")
