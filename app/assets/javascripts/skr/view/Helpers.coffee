_=Skr.u;


Skr.View.Helpers = {

    grid_widths: (widths...)->
        return ["col-xs-#{widths[0] || 3}"] if widths.length < 2
        widths = ( "col-#{width}-#{widths[index]}" for index,width of (['xs','sm','md','lg'][0..widths.length-1]) )
        widths.join(' ')

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