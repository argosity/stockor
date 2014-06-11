
Skr.View.fn = {

    toggleClass: (class_name, selector='')->
        {
            selector: '', elAttribute: 'class', converter:
                (dir,value)-> if value then class_name else ''
        }

    onEnter: (method)->
        (ev)->
            this[method](ev) if 13 == ev.keyCode
}