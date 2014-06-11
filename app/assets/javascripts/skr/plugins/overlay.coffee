( ($,_,getRoot)->

    $.fn.overlay = (options={})->

        return this.each ->
            $this = $(this)
            data = $this.data();

            if 'showing' == options
                return !!data.spinner

            if false == options
                data.overlay.remove()
                delete data.overlay
                return

            options={ msg: options } if _.isString(options)
            root = getRoot()
            unless data.overlay
                el = $("""
                    <div class='overlay'>
                        <div class='mask'></div>
                        <div class='message'><i></i><p></p></div>
                    </div>
                """)
                root.append(el)
                position = $this.offset()
                root_position = root.offset()
                position.left -= root_position.left
                position.top  -= root_position.top
                data.overlay = el.css({
                    height: $this.height(), width: $this.width(),
                    left: position.left, top: position.top
                })
            message = data.overlay.find('.message')
            icon = message.find('i')
            icon.css('color',  options.color)      if options.color
            icon.attr('class', options.icon)       if options.icon
            if options.msg
                message.find('p').text(options.msg)
                message.toggleClass('short',  options.msg.length < 25 )
            $this

)(Skr.$,Skr.u, ->
    Skr.View.InterfaceState.get('viewport')
);
