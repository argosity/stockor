_=Skr.u;


Skr.View.Helpers = {

    grid_widths: (widths...)->
        last = widths[widths.length-1]
        widths.push(last) for i in [widths.length-1..4]
        ( "col-#{width}-#{widths[index]}" for index,width of ['xs','sm','md','lg'] ).join(' ')

    context: new Skr.View.RenderContext

    text_field: (name,options)->
        options.widths=[options.width] if options.width
        widths = this.grid_widths(options.widths...)
        title  = Skr.u.escape( options.label || Skr.u.titleize(name) )
        if this.context.canRead(name)
            contents = "<label class='skr #{widths}'>#{title}:"
            contents += if this.context.canUpdate(name)
                "<input type='text' name='#{name}'>"
            else
                "<div class='ro' name='#{name}'></div>"
            contents += "</label>"
        else
            contents = "<div class='#{widths}'></div>"
        result = new String(contents)
        result.HTMLSafe = true
        result


}