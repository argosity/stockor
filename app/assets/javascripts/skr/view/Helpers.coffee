_=Skr.u;


Skr.View.Helpers = {

    grid_widths: (widths...)->
        last = widths[widths.length-1]
        widths.push(last) for i in [widths.length-1..4]
        ( "col-#{width}-#{widths[index]}" for index,width of ['xs','sm','md','lg'] ).join(' ')

    text_field: (name,options)->
        options.widths=[options.width] if options.width
        widths = this.grid_widths(options.widths...)
        title  = Skr.u.escape( options.label || Skr.u.titleize(name) )
        result = new String("""
            <label class="skr #{widths}">#{title}:
            <input type="text" name="#{name}">
            </label>
        """)
        result.HTMLSafe = true
        result


}