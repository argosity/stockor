Skr.load = (files,callback,context)->
    js=Skr.u.filter(files, (file)->
        file.match(/.js$/)
    )
    css=Skr.u.filter(files, (file)->
        file.match(/.css$/)
    )
    loaded = needs = 0
    cb = ->
        loaded += 1
        callback.apply(context) if loaded == needs
    if js.length > 0
        needs +=1
        Skr._loader.js(js,cb)
    if css.length > 0
        needs +=1
        Skr._loader.css(css,cb)
