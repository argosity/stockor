_=Skr.u;


Skr.View.Helpers = {

    grid_widths: (widths...)->
        return ["col-md-#{widths[0] || 3}"] if widths.length < 2
        "col-#{width}-#{widths[index]}" for index,width of (['lg','md','sm','xs'][0..widths.length-1])

    text_field: (name,options)->
        options.widths=[options.width] if options.width
        widths = this.grid_widths(options.widths...)

        """
            <label class="skr #{widths.join(' ')}">#{options.title||Skr.u.titleize(name)}:
            <input type="text" name="#{name}">
            </label>
        """


}